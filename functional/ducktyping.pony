use "collections"

class Foo
  fun doit(env: Env) =>
    env.out.print("do it with A")
  fun more(env: Env) =>
    env.out.print("You can add more interface")

class Bar
  fun doit(env: Env) =>
    env.out.print("do it with B")
  fun more(env: Env) =>
    env.out.print("You can add more interface")

interface Doit
  fun doit(env: Env)

interface More
  fun more(env: Env)

primitive Using
  fun doit(env: Env, d: (Doit box & More box)) =>
    d.doit(env)
    d.more(env)
  /*
    match d
    | let c: Foo box => c.doit(env)
    | let c: Bar box => c.doit(env)
    else
      env.out.print("Erreur")
    end
  */

actor DuckTypingDesign
  new create(env: Env) =>
    env.out.print("Duck Typing")
    let a: Foo box = Foo
    let b: Bar box = Bar
    let c: String box = "string"
    env.out.write("Using A do it: ")
    Using.doit(env, a)
    env.out.write("Using B do it: ")
    Using.doit(env, b)
    //env.out.write("Using String do it: ")
    //Using.doit(env, c)