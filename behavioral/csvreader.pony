use "collections"
use "files"

primitive CSVReader
  fun open(env: Env, file_name: String): List[List[String]] ? =>

    let path = FilePath(env.root as AmbientAuth, file_name)?
    let persons: List[List[String]] = List[List[String]](0) 
    match OpenFile(path)
    | let file: File =>
      let lines: FileLines = FileLines(file)
      while lines.has_next() do
        let temp: Array[String] = (lines.next()).split(",")
        let fields: List[String] = List[String](0)
        for k in Range(0, temp.size()) do
          let field: String iso = temp(k)?.clone()
          field.strip()
          fields.push(consume field)
        end
        let person: List[String] = fields
        persons.push(person)
      end
    else
      error
    end
    persons
