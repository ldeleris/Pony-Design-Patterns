use "json"

primitive JSONReader
  fun open(file_name: String): JsonDoc ? =>
    let doc: JsonDoc = JsonDoc
    doc.parse("""
    [
      {
        "name": "Laurent",
        "age": 50,
        "address": "Salvagnac"  
      },
      {
        "name": "Pierre",
        "age": 25,
        "address": "Toulouse"
      }
    ]
    """)?
/*
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
        for i in Range(0, person.size()) do
          env.out.print(person(i)?.string())
        end
      end
    else
            //env.err.print("Error opening file '" + file_name + "'")
      error
    end
*/
    doc