use "collections"

trait Expr
  fun interpret():  U64 ?
  fun string(): String iso^

class Num is Expr
  let n: U64 

  new create(n': U64) => n = n'

  fun interpret(): U64 ? => 
    match n 
    | let n': U64 => n'
    else
      error
    end
  
  fun string(): String iso^ =>
    n.string()

class Add is Expr
  let right: Expr
  let left: Expr

  new create(r: Expr, l: Expr) =>
    right = r 
    left = l 
  
  fun interpret(): U64 ? =>
    left.interpret()? + right.interpret()?

  fun string(): String iso^ =>
    ("Add(" + left.string() + ", " + right.string() + ")").string()

class Subtract is Expr
  let right: Expr
  let left: Expr

  new create(r: Expr, l: Expr) =>
    right = r 
    left = l 
  
  fun interpret(): U64 ? =>
    left.interpret()? - right.interpret()?

  fun string(): String iso^ =>
    ("Add(" + left.string() + ", " + right.string() + ")").string()

class Multiply is Expr
  let right: Expr
  let left: Expr

  new create(r: Expr, l: Expr) =>
    right = r 
    left = l 
  
  fun interpret(): U64 ? =>
    left.interpret()? * right.interpret()?

  fun string(): String iso^ =>
    ("Add(" + left.string() + ", " + right.string() + ")").string()

class Leaf is Expr
  fun interpret(): U64 ? => 
    if true then 0 else error end

  fun string(): String iso^ =>
    "Leaf".string()

primitive Expression
  fun apply(operator: String, left: Expr, right: Expr): (None | Expr) =>
    match operator
    | "+" => Add(right, left)
    | "-" => Subtract(right, left)
    | "*" => Multiply(right, left)
    | let s: String => 
      try
        Num(StringParser.parse_u64(s)?)
      else
        None
      end
    else
      None
    end

primitive RPNParser
  fun parse(expression: String): Expr ? =>
    let tokenizer: List[String] = List[String].from(expression.split(" "))
    tokenizer.fold[List[Expr]]({ (result: List[Expr]!, token: this->String!): List[Expr] =>
      //let result: List[Expr] = result'.clone()
      let left: Expr = try result.pop()? else Leaf end
      let right: Expr = try result.pop()? else Leaf end
      let item = Expression(token.string(), left, right)
      match item 
      | let e: Expr => result.push(e)
      end
      result
    } , List[Expr]()).pop()? //.shift()?

primitive RPNInterpreter
  fun interpret(expression: Expr): U64 ?=>
    expression.interpret()?

actor Interpreter
  new create(env: Env) =>
    env.out.print("Interpreter:")
    let expr = [ 
      "1 2 + 3 * 9 10 + -"
      "1 2 3 4 5 * * - +"
      "12 -"
      "-"
      "+ 1 2"
      ]
    for e in expr.values() do
      try
        let expression = RPNParser.parse(e)?
        let result = RPNInterpreter.interpret(expression)?
        env.out.print(expression.string())
        env.out.print("The result of '" + e + "' is: " + result.string())
      else
        env.out.print("'" + e + "'" + " is invalid.")
      end
    end

  