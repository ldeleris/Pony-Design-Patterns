use "collections"

class Memoizer[T: (Hashable #read & Equatable[T val] #read), Y: Any val]
  let cache: Map[T, Y] = Map[T, Y]() 
  let f: {(T): Y}

  new create(f': {(T): Y}) => f = f'

  fun ref apply(x: T): Y ? => 
    if cache.contains(x) then
      cache(x)?
    else  
      cache.insert(x, f(x))?
    end

primitive OneFunction
  fun doit(x: U64): U64 =>
    let delay: U64 = 3000
    @Sleep[I64](delay)
    x

actor MemoizationDesign
  new create(env: Env) =>
    env.out.print("Memoization: ")
    let doit_memo = Memoizer[U64,U64](OneFunction~doit())
    try
      env.out.write("doit(10): ")
      env.out.print(doit_memo(10)?.string())
      env.out.write("doit(20): ")
      env.out.print(doit_memo(20)?.string())
      env.out.write("doit(10): ")
      env.out.print(doit_memo(10)?.string())
    end
