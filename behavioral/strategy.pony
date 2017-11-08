use "collections"
use "json"

type OptPerson is (Person | None)

class Person
  let name: String 
  let age: U64
  let address: String

  new create(name': String, age': U64, address': String) =>
    name = name'
    age = age'
    address = address'

  fun string(): String iso^ =>
    ("Person(" + name + ", " + age.string() + ", " + address + ")").string()

trait Parser[T]
  fun parse(file: String): List[T] ?

class CSVParser is Parser[OptPerson]
  let _env: Env

  new create(env: Env) => _env = env 

  fun parse(file: String): List[OptPerson] ? =>
    CSVReader.open(_env, file)?.map[OptPerson]({(l: this->List[String]): OptPerson =>
      try 
        let temp: String = l(1)?
        Person(l(0)?, StringParser.parse_u64(temp)?, l(2)?) 
      else 
        None
      end    
    })

class JSONParser is Parser[OptPerson]
  let _env: Env

  new create(env: Env) => _env = env 

  fun parse(file: String): List[OptPerson] ? =>
    let doc: JsonDoc = JSONReader.open(file)?
    let persons: List[OptPerson] = List[OptPerson](0)

    let arrays = doc.data as JsonArray
    for indice in Range(0, arrays.data.size()) do
      let person = arrays.data(indice)? as JsonObject
      let name = person.data("name")? as String
      let age = (person.data("age")? as I64).u64()
      let address = person.data("address")? as String
      persons.push(Person(name, age, address))
    end

    persons 

primitive PersonsParser // factory
  fun apply(env: Env, file: String): Parser[OptPerson] ? =>
    match file
    | let f: String if f.contains(".json") => 
        env.out.print("json file...")
        JSONParser(env)
    | let f: String if f.contains(".csv") => 
      env.out.print("csv file...")
      CSVParser(env)
    else
      error
    end

class PersonApplication
  let _env: Env
  let _parser: Parser[OptPerson]

  new create(env: Env, parser: Parser[OptPerson]) =>
    _env = env
    _parser = parser
  
  fun write(file: String) ? =>
    let persons: List[OptPerson] = _parser.parse(file)?
      for p in Range(0, persons.size()) do
        _env.out.print("Persons: " + persons(p)?.string())
      end

// Strategy design functional way
primitive StrategyFactory
  fun apply(env: Env, file_name: String): {(String): List[OptPerson] ?} ? =>
    match file_name
    | let f: String if f.contains(".json") => 
      env.out.print("json file...")
      let function: {(String): List[OptPerson] ? } = this~parse_json(env)?
      function
    | let f: String if f.contains(".csv") => 
      env.out.print("csv file...")
      let function: {(String): List[OptPerson] ? } = this~parse_csv(env)?
      function
    else
      error
    end   

  fun parse_json(env: Env, file: String): List[OptPerson] ? =>
    let doc: JsonDoc = JSONReader.open(file)?
    let persons: List[OptPerson] = List[OptPerson](0)
    let arrays = doc.data as JsonArray
    for indice in Range(0, arrays.data.size()) do
      let person = arrays.data(indice)? as JsonObject
      let name = person.data("name")? as String
      let age = (person.data("age")? as I64).u64()
      let address = person.data("address")? as String
      persons.push(Person(name, age, address))
    end 
    persons  


  fun parse_csv(env: Env, file: String): List[OptPerson] ? =>
    CSVReader.open(env, file)?.map[OptPerson]({(l: this->List[String]): OptPerson =>
      try 
        let temp: String = l(1)?
        Person(l(0)?, StringParser.parse_u64(temp)?, l(2)?) 
      else 
        None
      end    
    })

class Application
  let _strategy:  { (String): List[OptPerson] ? } 

  new create(strategy:  { (String): List[OptPerson] ? }) =>
    _strategy = strategy

  fun write(env: Env, file: String) ? =>
    let persons: List[OptPerson] = _strategy(file)?
      for p in Range(0, persons.size()) do
        env.out.print("Persons: " + persons(p)?.string())
      end    

actor Strategy
  new create(env: Env) =>
    env.out.print("Strategy:")
    let csv_file = "C:\\Users\\Laurent\\pony\\patterns\\persons.csv"
    let json_file = "C:\\Users\\Laurent\\pony\\patterns\\persons.json"
    try
      let csvPeople: Parser[OptPerson] = PersonsParser(env, csv_file)?
      let jsonPeople: Parser[OptPerson] = PersonsParser(env, json_file)?
      let applicationCsv = PersonApplication(env, csvPeople)
      let applicationJson = PersonApplication(env, jsonPeople)

      env.out.print("Using the csv:")
      applicationCsv.write(csv_file)?

      env.out.print("Using the json:")
      applicationJson.write(json_file)?

      let csv_app = Application(StrategyFactory(env, csv_file)?)
      let json_app = Application(StrategyFactory(env, json_file)?)
      env.out.print("Strategy factory: Using the csv:")
      csv_app.write(env, csv_file)?
      env.out.print("Strategy factory: Using the json:")
      json_app.write(env, json_file)?
    else  
      env.out.print("Oups...!")     
    end
