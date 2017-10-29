use factory = "factory"

actor Main
  new create(env: Env) =>
    env.out.print("Hello, world!")

    factory.Factory(env)
    factory.Abstract(env)
    
