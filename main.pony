use creational = "creational"
use structural = "structural"
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
    
