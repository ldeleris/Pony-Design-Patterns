use "collections"

/*
primitive LensFunctions[X, Y]
  fun lensu[A, B](set: {(A, B): A}, get: {(A): B}): Lens[A, B] =>
    lensg(set.curried, get)
*/

class Country
  let name: String
  let code: String

  new create(n: String, c: String) =>
    name = n
    code = c 

  fun string(): String iso^ =>
    ("Country(" + name.string() + ", " + code.string() + ")").string()

class City
  let name: String
  embed country: Country 

  new create(n: String, c: Country) =>
    name = n 
    country = Country(c.name, c.code) 

  fun string(): String iso^ =>
    ("City(" + name.string() + ", " + country.string() + ")").string()

class Address
  let number: U64
  let street: String
  embed city: City

  new create(n: U64, s: String, c: City) =>
    number = n 
    street = s 
    city = City(c.name, c.country)

  fun string(): String iso^ =>
    ("Address(" + number.string() + ", " + street.string() + ", " + city.string() + ")").string()

class Company
  let name: String
  embed address: Address

  new create(n:String, a: Address) =>
    name = n 
    address = Address(a.number, a.street, a.city) 
  
  fun string(): String iso^ =>
    ("Company(" + name.string() + ", " + address.string() + ")").string()

class User
  let name: String
  embed company: Company
  embed address: Address

  new create(n: String, c: Company, a: Address) =>
    name = n 
    company = Company(c.name, c.address) 
    address = Address(a.number, a.street, a.city) 

  fun string(): String iso^ =>
    ("User(" + name.string() + ", " + company.string() + ", " + address.string() + ")").string()



actor LensDesign
  new create(env: Env) =>
    env.out.print("Lens:")
    let uk = Country("United Kingdom", "UK")
    let london = City("London", uk)
    let buckingham_palace = Address(1, "Buckingham Palace Road", london)
    let castle_builders = Company("Castle Builders", buckingham_palace)

    let switzerland = Country("Switzerland", "CH")
    let geneva = City("Geneva", switzerland)
    let geneva_address = Address(1, "Geneva Lake", geneva)

    let ivan = User("Ivan", castle_builders, geneva_address)
    env.out.print(ivan.string())
