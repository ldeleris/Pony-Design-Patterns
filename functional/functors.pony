use "collections"

type Opt[A: Stringable val] is (Some[A] | Null[A])
//type List[A] is (Cons[A] | Nil[A])

/*
interface Functor[A]
  fun map[B](f: {(this->A): B} ): Functor[B]^


interface box Monad[A]
  fun unit(value: A): Monad[A]
  fun flatMap[B]](f: {(this->A): Monad[B]^ } ): Monad[B]^
  //fun map[B: Any val](f: {(A): B} ): Functor[B]^

//trait Option[A: Stringable val] is Monad[A]

trait Optional[A] is (Functor[A] & Monad[A])
*/
class val Some[A: Stringable val]
  let a: A

  new create(a': A) => a = a'

  new val unit(a': A) => a = a'
  
  fun map[B: Stringable val](f: {(this->A): B} ): Opt[B]^ => 
    Some[B].unit(f(a))
  
  fun flatMap[B: Stringable val](f: {(this->A): Opt[B]^ } ): Opt[B]^ =>
    f(a)

  fun string(): String iso^ => ("Some(" + a.string() + ")").string()

primitive Null[A: Stringable val]
  
  fun unit(): Opt[A] => Null[A]
  
  fun map[B: Stringable val](f: {(this->A): B} ): Opt[B]^ => 
    Null[B].unit()
  
  fun flatMap[B: Stringable val](f: {(this->A): Opt[B]^ } ): Opt[B]^ =>
    Null[B].unit()

  fun string(): String iso^ => "Null()".string()

class val Implementation is Stringable
  let left: U64
  let right: U64

  new val create(l: U64, r: U64) => 
    left = l
    right = r 
  
  fun compute(): U64 => left + right

  fun string(): String iso^ =>
  ("Implementation(" + left.string() + " + " + right.string() + ")").string()

primitive Doer is Stringable
  fun get_algorithm(is_fail: Bool): Opt[Algorithm] =>
    if is_fail then
      Null[Algorithm].unit()
    else
      Some[Algorithm].unit(Algorithm)
    end

  fun string(): String iso^ => "Doer: ".string()

primitive Algorithm is Stringable
  fun get_implementation(is_fail: Bool, left: U64, right: U64): Opt[Implementation] =>
    if is_fail then
      Null[Implementation].unit()
    else
      Some[Implementation].unit(Implementation(left, right))
    end
  
  fun string(): String iso^ => "Algorithm: ".string()


actor FunctorsDesign
  new create(env: Env) =>
    env.out.print("Functors:")
    let numbers: List[Opt[U64]] = List[Opt[U64]].from([
      Some[U64].unit(1)
      Some[U64].unit(2)
      Some[U64].unit(3)
      Null[U64].unit()
      Some[U64].unit(4)
    ])
    let results1: List[Opt[U64]] = numbers.map[Opt[U64]]({ (o: Opt[U64]): Opt[U64] => o.map[U64]({ (x: U64): U64 => x + 1})})
    for r in results1.values() do
      env.out.print(r.string())
    end

    let chaines: List[Opt[String]] = List[Opt[String]].from([
      Some[String].unit("Pony")
      Some[String].unit("Is")
      Some[String].unit("Object")
      Null[String].unit()
      Some[String].unit("Concurrent")
    ])
    let results2: List[Opt[USize]] = chaines.map[Opt[USize]]({ (o: Opt[String]): Opt[USize] => o.map[USize]({ (x: String): USize => x.size()})})
    for r in results1.values() do
      env.out.print(r.string())
    end

    env.out.print("The result is: " + compute(Some[Doer].unit(Doer), 10, 10).string())

    fun compute(doer: Opt[Doer], left: U64, right: U64): Opt[U64] =>
      doer.
        flatMap[Algorithm]({(d: Doer): Opt[Algorithm] => d.get_algorithm(false)}).
        flatMap[Implementation]({(a: Algorithm): Opt[Implementation] => a.get_implementation(false, left, right)}).
        map[U64]({(i: Implementation):U64 => i.compute()})
    
