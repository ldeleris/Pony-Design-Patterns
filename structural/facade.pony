use "lib:Kernel32"
use "encode/base64"
use "json"


trait DataDownloader
  fun download(env: Env, url: String): String =>
    let delay: U32 = 100
    env.out.print("Downloading from: " + url) 
    @Sleep[I64](delay)
    "ew0KICAgICJuYW1lIjogIkl2YW4iLA0KICAgICJhZ2UiOiAyNg0KfQ=="

trait DataDecoder
  fun decode(data: String): String =>
    try
      Base64.decode[String iso](data)?
    else
      ""
    end

trait DataDeserializer
  fun parse(data: String): Person ? =>
    let doc: JsonDoc = JsonDoc
    doc.parse(data)?
    let obj = doc.data as JsonObject
    let name = obj.data("name")? as String
    let age = obj.data("age")? as I64
    Person(name, age)

class Person
  let name: (String | None)
  let age: (I64 | None)

  new create(name': (String | None), age': (I64 | None)) =>
    name = name'
    age = age'

  fun string(): String =>
    "Person(" + name.string() + ", " + age.string() + ")"

primitive DataReader is (DataDownloader & DataDecoder & DataDeserializer)
  fun readPerson(env: Env, url: String): (Person | None) =>
    let data = download(env, url)
    let json = decode(data)
    try
      parse(json)?
    else
      None
    end

actor Facade
  new create(env: Env) =>
    env.out.print("Facade:")
    env.out.print(DataReader.readPerson(env, "http://www.ivan-nikolov.com/").string())
