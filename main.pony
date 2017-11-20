use creational = "creational"
use structural = "structural"
use behavioral = "behavioral"
use functional = "functional"

actor Main
  new create(env: Env) =>
    env.out.print("Hello, world!")

    creational.Factory(env)
    creational.Abstract(env)
    creational.Static(env)
    creational.Lazy(env)
    creational.Singleton(env)
    creational.Builder(env)
    creational.Prototype(env)

    structural.Adapter(env)
    structural.Decorator(env)
    structural.Bridge(env)

    let house: structural.HouseOneDoor = structural.HouseOneDoor(structural.HouseDoorKey)
    env.out.print(house.enter())
    env.out.print(house.leave())

//can't access a private type from another package
//  let door: structural._Door = structural._Door(structural.HouseDoorKey)

    structural.Composite(env)
    structural.Facade(env)
    structural.Flyweight(env)
    structural.Proxy(env)

    behavioral.ValueObject(env)
    behavioral.NullObject(env)
    behavioral.Strategy(env)
    behavioral.Command(env)
    behavioral.ChainOfResponsability(env)
    behavioral.Interpreter(env)
    behavioral.MediatorDesign(env)
    behavioral.MementoDesign(env)
    behavioral.ObserverDesign(env)
    behavioral.StateDesign(env)
    behavioral.TemplateMethod(env)
    behavioral.VisitorDesign(env)

    functional.MonoidDesign(env)