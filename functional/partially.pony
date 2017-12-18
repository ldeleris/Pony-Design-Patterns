use "collections"

primitive PartiallyDefineFunctions
  fun square_root(x: F64): F64 ? =>
    if x >= 0 then @sqrt[F64](x)
    else
      error
    end
  fun collect(list: List[F64], f: {(F64): F64 ?}): List[F64] =>
    let res: List[F64] = List[F64]()
    for x in list.values() do
      try 
        res.push(f(x)?) 
      end
    end
    res

  fun print(env: Env, list: Seq[F64]) =>
    env.out.write("List(")
    for x in list.values() do
      env.out.write(x.string() + ", ")
    end
    env.out.print(")")

class PartialFunction[A: Any #read,B: Any #read]
  let func: {(A): B} box
  let pred: {(A): Bool}

  new create(f: {(A): B}, p: {(A): Bool}) =>
    func = f 
    pred = p 
  
  fun is_defined(x: A): Bool =>
    pred(x)

  fun apply(x: A): B ? =>
    if pred(x) then
      func(x)
    else
      error
    end  

  fun or_else(x: A, opt: PartialFunction[A,B]): B ? =>
    if pred(x) then
      func(x)
    else
      opt(x)?
    end 

  fun and_then(x: A, opt: PartialFunction[B,B]): B ? =>
    if pred(x) then
      opt(func(x))?
    else
      error
    end 


  fun collect(list: Seq[A]): Seq[B] =>
    let res: List[B] = List[B]()
    for x in list.values() do
      try 
        res.push(this(x)?) 
      end
    end
    res

actor PartiallyDesign
  new create(env: Env) =>
    env.out.print("Partially: ")
    let items = List[F64].from([-1; 10; 11; -36; 36; -49; 49; 81])
    let results = PartiallyDefineFunctions.collect(items, PartiallyDefineFunctions~square_root())
    PartiallyDefineFunctions.print(env, results)

    let pf = PartialFunction[F64,F64]({(x: F64): F64 => @sqrt[F64](x)}, {(x: F64): Bool => x >= 0})
    env.out.print("Can we calculate a root for -10: " + pf.is_defined(-10).string())
    PartiallyDefineFunctions.print(env, pf.collect(items))

    let pf_else = PartialFunction[F64,F64]({(x: F64): F64 => 0}, {(x: F64): Bool => true})
    let pf_then = PartialFunction[F64,F64]({(x: F64): F64 => x + 1}, {(x: F64): Bool => true})
    let pf2 = PartialFunction[F64,String]({(x: F64): String => x.string()}, {(x: F64): Bool => true})
    try
      env.out.print("Calculate a root for -10: " + pf.or_else(-10, pf_else)?.string())
      env.out.print("Calculate a root and add 1: " + pf.and_then(4, pf_then)?.string())
      env.out.print(pf2(101.23)?)
     
    end