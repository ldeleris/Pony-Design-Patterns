use "collections"

trait DatabaseService
  fun get_people(): List[Person]

class DatabaseServiceImpl is DatabaseService
  fun get_people(): List[Person] =>
    List[Person].from([
      Person("Ivan", 26)
      Person("Maria", 25)
      Person("John", 23)
    ])

trait UserService
  fun ref get_average_age_of_people(): F64 

type Result is (U64, U64)

class UserServiceImpl is UserService
  let ds: DatabaseService

  new create(ds': DatabaseService) => ds = ds'

  fun ref get_average_age_of_people(): F64 =>
    
    //(let s: U64, let c: U64) = 
    //let res: (U64, U64) = ds.get_people().fold[Result]({(acc: Result, p: Person): Result^ =>
    //  (acc._1 + p.age, acc._2 + 1)} box, (0,0))
    //res._1.f64() / res._2.f64()
    var sum: U64 = 0
    let people: List[Person] = ds.get_people()
    for i in Range(0, people.size()) do
      try sum = sum + people(i)?.age end
    end
    sum.f64() / people.size().f64()


actor ImplicitDesign
  new create(env: Env) =>
    env.out.print("Implicit:")
    let user_service = (object
      fun apply(): UserService => UserServiceImpl(DatabaseServiceImpl)
    end)()
    env.out.print("The average age of the people is: " + user_service.get_average_age_of_people().string())
