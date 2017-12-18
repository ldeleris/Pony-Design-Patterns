use "collections"

/*
interface Num[T]
  fun plus(x: T, y: T): T 
  fun minus(x: T, y: T): T 
  fun divide(x: T, y: T): T 
  fun multiply(x: T, y: T): T 
  fun sqrt(x: T): T 


primitive Flotant is Num[F64]
  fun plus(x: F64, y: F64): F64 => x + y
  fun minus(x: F64, y: F64): F64 => x - y
  fun divide(x: F64, y: F64): F64 => x / y
  fun multiply(x: F64, y: F64): F64 => x * y
  fun sqrt(x: F64): F64 => x

primitive Stats[T: Any val]
  fun mean(xs: List[T] val): T ? =>
    match xs
    | let ys: List[F64] val => Flotant.divide(ys.fold[F64]({(acc: F64, y: F64): F64=>
      acc + y}, 0.0), ys.size().f64() )
    else
      error
    end
*/
actor TypeClassDesign
  new create(env: Env) =>
    env.out.print("Type Class:")
    //let numbers = List[F64].from([1.1; 2.1; 3.1; 4.1])
    //env.out.print(Stats[F64].mean(numbers).string())