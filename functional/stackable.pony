/*
interface StringWriter
  fun write(data: String): String

class BasicStringWriter is StringWriter
  fun write(data: String): String =>
    "Writing the following data: " + data

trait CapitalizingStringWriter is StringWriter
  fun apply(): StringWriter => object is CapitalizingStringWriter end
  fun write(data: String): String =>
    this.write("Capitalize: " + data)

trait UppercasingStringWriter is StringWriter
  fun apply(): StringWriter => BasicStringWriter
  fun write(data: String): String =>
    this.write("Upper: " + data)

trait LowercasingStringWriter is StringWriter
  fun apply(): StringWriter => BasicStringWriter
  fun write(data: String): String =>
    this.write("Lower: " + data)

actor StackableDesign
  new create(env: Env) =>
    env.out.print("Stackable:")
    let writer1 = object is CapitalizingStringWriter end
    env.out.print(writer1.write("Hello world!"))
*/