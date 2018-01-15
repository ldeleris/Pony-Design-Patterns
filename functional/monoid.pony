use "collections"

trait Monoid[T]
  fun op(l: T, r: T): T 
  fun zero(): T 


primitive NumAdd is Monoid[U64]
  fun zero(): U64 => 0
  fun op(l: U64, r: U64): U64 => l + r
  

primitive NumMul is Monoid[U64] 
  fun zero(): U64 => 1
  fun op(l: U64, r: U64): U64 => l * r
     
primitive StringConcatenation is Monoid[String] 
  fun zero(): String => ""
  fun op(l: String, r: String): String => l + r  

primitive MonoidOperation
  fun fold[T: Any val](list: List[T], m: Monoid[T] box): T =>
    list.fold[T](m~op(), m.zero())
  
  fun foldMap[T: Any val, Y: Any val](list: List[T], m: Monoid[Y] box, f: {(T): Y}): Y =>
    list.fold[Y]({(t: Y, y: T): Y => m.op(t, f(y))}, m.zero())

  fun id[T](x: T): T => x

  fun foldm[T: Any val](list: List[T], m: Monoid[T] box): T =>
    foldMap[T, T](list, m, this~id[T]())

  fun balance_fold[T: Any val, Y: Any #read](list: List[T], m: Monoid[Y] box, f: {(T): Y}): Y ? =>
    if list.size() == 0 then
      m.zero()
    elseif list.size() == 1 then
      f(list(0)?)
    else
      (let left: List[T], let right: List[T]) = _split[T](list, list.size() / 2)
      m.op(balance_fold[T,Y](left, m, f)?, balance_fold[T,Y](right, m, f)?)
    end

  fun compose[T: Any val, Y: Any val](a: Monoid[T] box, b: Monoid[Y] box): Monoid[(T, Y)] =>
    object is Monoid[(T, Y)]
      fun zero(): (T, Y) => (a.zero(), b.zero())
      fun op(l: (T, Y), r: (T, Y)): (T, Y) => 
        (a.op(l._1, r._1), b.op(l._2, r._2))
    end

  fun map_merge[K: (Hashable  #read & Equatable[K] #read), V: Any val](a: Monoid[V] box): Monoid[Map[K, V]] box =>
    object box is Monoid[Map[K, V]]
      let _a: Monoid[V] box =  a
      fun zero(): Map[K, V] => Map[K, V]()
      fun op(l: Map[K, V], r: Map[K, V]): Map[K, V] =>
        let m: Map[K, V] = Map[K, V]()
        let left_keys = l.keys()
        let left: List[K] = List[K]()
        while left_keys.has_next() do
          try 
            left.push(left_keys.next()?)
          end
        end
        let right_keys = r.keys()
        let right: List[K] = List[K]()
        while right_keys.has_next() do
          try
            right.push(right_keys.next()?)
          end
        end
        left.concat(right.values())
        for key in left.values() do
          try 
            m.insert(key,  _a.op(l.get_or_else(key, _a.zero()), r.get_or_else(key, _a.zero())))?
          end
        end
        m
        //Map[K, V]()

    end

  fun _split[T: Any val](list: List[T], n: USize): (List[T], List[T]) =>
    let pivot: USize = list.size() / 2
    let left: List[T] = list.take(pivot)
    let right: List[T] = list.reverse().take(list.size() - pivot)
    (left, right)

actor MonoidDesign
  new create(env: Env) =>
    env.out.print("Monoid:")
    let strings: List[String] = List[String].from(["this is\n"; "a list of\n"; "strings!"])
    let numbers: List[U64] = List[U64].from([1;2;3;4])

    env.out.print(strings.fold[String](StringConcatenation~op(), StringConcatenation.zero()).string())
    env.out.print(numbers.fold[U64](NumAdd~op(), NumAdd.zero()).string())
    env.out.print(numbers.fold[U64](NumMul~op(), NumMul.zero()).string())

    env.out.print("Monoid operations: " + (MonoidOperation.fold[String](
      strings, StringConcatenation)))

    env.out.print("Monoid operations foldMap: " + (MonoidOperation.foldm[String](
      strings, StringConcatenation)))

    try
      env.out.print("4! is: " + 
        MonoidOperation.balance_fold[U64, U64](numbers, NumMul, MonoidOperation~id[U64]())?.string())
    end

    let nums: List[U64] = List[U64].from([1;2;3;4;5;6])
    let sum_and_product: Monoid[(U64, U64)] = MonoidOperation.compose[U64, U64](NumAdd, NumMul)
    
    env.out.write("The sum and product is: ")
    try
      let res: (U64, U64) = MonoidOperation.balance_fold[U64, (U64, U64)](nums, sum_and_product, {(i: U64): (U64, U64) => (i, i)})?
    
      env.out.print("(" + res._1.string() + ", " + res._2.string() + ")")
    end

    let features: List[String] = List[String].from([
      "hello"
      "features"
      "for"
      "ml"
      "hello"
      "for"
      "features"
    ])
    let counter_monoid: Monoid[Map[String, U64]] box = MonoidOperation.map_merge[String, U64](NumAdd)
    
    env.out.write("The features are:")

    try
    let maps: Map[String, U64] = MonoidOperation.balance_fold[String, Map[String, U64]](features, counter_monoid, {(s: String): Map[String, U64] => 
      let m: Map[String, U64] = Map[String, U64]()
      try m.insert(s, 1)? end
      m} )?

    let k = maps.keys()
    env.out.write(" [")
    while k.has_next() do
      let key = k.next()?
      env.out.write(key.string() + " -> " + maps(key)?.string() + ", ")
    end
    env.out.print("]")
    end

  