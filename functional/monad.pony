use "collections"
/*
trait StateM
  fun next(): StateM

class FileIO
  fun run(args: Array[String]) =>
    let action = runIO(args(0), args(1))
    action(_FileIOState(0))
  
  fun runIO(read_path: String, write_path: String): IOAction

primitive _FileIOState is StateM
  fun apply(id': U64) => Object is StateM
    let id: U64 = id'
    fun next(): StateM => _FileIOState(id + 1)
*/
actor MonadsDesign
  new create(env: Env) =>
    env.out.print("Monads:")