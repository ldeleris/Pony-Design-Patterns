use "collections"

class Person
  let name: String 
  let age: U64

  new create(n:String, a: U64) => name = n; age = a 

  fun string(): String iso^ =>
    ("Person(" + name + ", " + age.string() + ")").string()

primitive DatabasePerson
  fun get_from_database(env: Env): List[Person] =>
    let t: I64 = 3000
    env.out.print("Retrieving people...")
    @Sleep[I64](t)
    List[Person].from([
      Person("Ivan", 26)
      Person("Maria", 25)
      Person("John", 24)
    ])

  fun print_people_bad(env: Env, people: {(): List[Person]}) =>
    env.out.write("Print first time: ")
    for p in people().values() do 
      env.out.write(p.string() + ", ")
    end
    env.out.print("")
    env.out.write("Print second time: ")
    for p in people().values() do 
      env.out.write(p.string() + ", ")
    end
    env.out.print("")

  fun print_people_good(env: Env, people: {(): List[Person]}) =>
    let people' = people()

    env.out.write("Print first time: ")
    for p in people'.values() do 
      env.out.write(p.string() + ", ")
    end
    env.out.print("")
    env.out.write("Print second time: ")
    for p in people'.values() do 
      env.out.write(p.string() + ", ")
    end
    env.out.print("")


actor LazyDesign
  new create(env: Env) =>
    env.out.print("Lazy:")
    env.out.print("BAD:")
    DatabasePerson.print_people_bad(env, DatabasePerson~get_from_database(env))
    env.out.print("GOOD:")
    DatabasePerson.print_people_good(env, DatabasePerson~get_from_database(env))