use "collections"

primitive StringParser 
  fun parse_u64(str: String val): U64 ? =>
    var s: String ref =  str.clone()
    var n: U64 = 0
    
    n = convert(s.shift()?)?
    for i in Range(0, s.size()) do      
      n = (n * 10) + convert(s.shift()?)?
    end
    n

  fun convert(c: U8): U64 ? =>
    match c
    | '0' => 0
    | '1' => 1
    | '2' => 2
    | '3' => 3
    | '4' => 4
    | '5' => 5
    | '6' => 6
    | '7' => 7
    | '8' => 8
    | '9' => 9
    else  
      error
    end
/*
actor Main
  new create(env: Env) =>
    try env.out.print(StringParser.parse_u64("12n34")?.string()) end
*/