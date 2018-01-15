use "collections"
use "json"

trait DataFinder[T: Any ref, Y]
  fun ref find(f: {(T): (None | Y)}): (None | Y) =>
    try
      let data: Array[U8] = read_data()
      let parsed: T = match parse(data)?
      | let res: T => res
      end
      f(parsed)
    then
      cleanup()
    end
  
  fun ref read_data(): Array[U8]
  fun ref parse(data: Array[U8]): T ?
  fun cleanup()

class JsonDataFinder is DataFinder[List[Person], Person]
  let env: Env

  new create(env': Env) => env = env'

  fun ref read_data(): Array[U8] =>
    env.out.print("Reading json: read data.")
    Array[U8]()

  fun ref parse(data: Array[U8]): List[Person] ? =>
    env.out.print("Reading json: parse data.")
    let res: List[Person] = List[Person]()
    if true then 
      res
    else
      error
    end

  fun cleanup() =>
    env.out.print("Reading json: nothing to do.")

class CSVDataFinder is DataFinder[List[Person], Person]
  let env: Env

  new create(env': Env) => env = env'

  fun ref read_data(): Array[U8] =>
    env.out.print("Reading csv: read data.")
    Array[U8]()

  fun ref parse(data: Array[U8]): List[Person] ? =>
    env.out.print("Reading csv: parse data.")
    let res: List[Person] = List[Person].from([
      Person("Yvan", 25, "Glasgow")
      Person("Maria", 23, "London")
      Person("John", 20, "Paris")
    ])
    if true then 
      res
    else
      error
    end

  fun cleanup() =>
    env.out.print("Reading csv: nothing to do.")


actor TemplateMethod
  new create(env: Env) =>
    env.out.print("Template method:")
    let json_data_finder: DataFinder[List[Person], Person] = JsonDataFinder(env)
    let csv_data_finder: DataFinder[List[Person], Person] = CSVDataFinder(env)
    
    env.out.print("Find a person with name Yvan in the json file: " +
      json_data_finder.find({(persons: List[Person]): (None | Person)  => 
        try
          persons.take_while({(p: this->Person): Bool => p.name == "Yvan"} )(0)?
        else
          None
        end } ).string())

    env.out.print("Find a person with name Yvan in the csv file: " +
      csv_data_finder.find({(persons: List[Person]): (None | Person)  => 
        try
          persons.take_while({(p: this->Person): Bool => p.name == "Yvan"} )(0)?
        else
          None
        end } ).string())
