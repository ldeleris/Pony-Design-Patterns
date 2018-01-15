use "collections"

interface Color is (Hashable & Equatable[Color])
  fun eq(that: box->Color): Bool
  fun ne(that: box->Color): Bool
  fun apply(): String

class Red is Color
  fun apply(): String => "red"
  fun hash(): U64 =>
    HashByteSeq.hash("red")
  fun eq(that: box->Color): Bool =>
    hash() == that.hash()
  fun ne(that: box->Color): Bool =>
    not Red.eq(that)

class Green is Color
  fun apply(): String => "green"
  fun hash(): U64 =>
    HashByteSeq.hash("green")
  fun eq(that: box->Color): Bool =>
    hash() == that.hash()
  fun ne(that: box->Color): Bool =>
    not Red.eq(that)

class Blue is Color
  fun apply(): String => "blue"
  fun hash(): U64 =>
    HashByteSeq.hash("blue")
  fun eq(that: box->Color): Bool =>
    hash() == that.hash()
  fun ne(that: box->Color): Bool =>
    not Red.eq(that)

class Yellow is Color
  fun apply(): String => "yellow"
  fun hash(): U64 =>
    HashByteSeq.hash("yellow")
  fun eq(that: box->Color): Bool =>
    hash() == that.hash()
  fun ne(that: box->Color): Bool =>
    not Red.eq(that)

class Magenta is Color
  fun apply(): String => "magenta"
  fun hash(): U64 =>
    HashByteSeq.hash("magenta")
  fun eq(that: box->Color): Bool =>
    hash() == that.hash()
  fun ne(that: box->Color): Bool =>
    not Red.eq(that)

class _Circle
  let color: Color

  new create(color': Color) => color = color'

  fun string(): String => 
    "Circle(" + color() + ")"

class Circle
  let cache: Map[Color, _Circle] = Map[Color, _Circle]()

  fun ref apply(color: Color): _Circle ? =>
      cache.insert_if_absent(color, _Circle(color))?

  fun circles_created(): USize => cache.size()

type Scene is (I64, I64, F64, _Circle)

class Graphic
  let items: List[Scene] = List[Scene](0)

  fun ref add_circle(x: I64, y: I64, radius: F64, circle: _Circle) ? =>
    items.push((consume x, consume y, consume radius, consume circle) as Scene)
  
  fun draw(): String =>
    items.fold[String]({(acc: String, scene: this->Scene): String =>
          acc + "Drawing a circle at (" +
          scene._1.string() + ", " + scene._2.string() + ") with radius " +
          scene._3.string() + ": " +
          scene._4.string() + "\n" } box, "")

actor Flyweight
  new create(env: Env) =>
    env.out.print("Flyweight:")
    try
      let circle: Circle = Circle
      let graphic: Graphic = Graphic
      graphic.add_circle(1, 1, 1.0, circle(Green)?)?
      graphic.add_circle(1, 2, 1.0, circle(Red)?)?
      graphic.add_circle(2, 1, 1.0, circle(Blue)?)?
      graphic.add_circle(2, 2, 1.8, circle(Green)?)?
      graphic.add_circle(2, 3, 1.0, circle(Yellow)?)?
      graphic.add_circle(3, 2, 1.0, circle(Magenta)?)?
      graphic.add_circle(3, 3, 1.5, circle(Blue)?)?
      graphic.add_circle(4, 3, 1.2, circle(Blue)?)?
      graphic.add_circle(3, 4, 1.1, circle(Yellow)?)?
      graphic.add_circle(4, 4, 2.5, circle(Red)?)?

      env.out.print(graphic.draw())
      env.out.print("Total number of circle objects created:" +
      circle.circles_created().string())
    end