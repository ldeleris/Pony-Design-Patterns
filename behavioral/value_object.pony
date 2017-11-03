use "collections"

type DateTuple is (U64, String, U64)

class Date 
  let day: U64
  let month: String
  let year: U64

  new create(day': U64, month': String, year': U64) =>
    day = day'
    month = month'
    year = year'

  // (Hashable & Equatable[Date]) for == et !=
  fun hash(): U64 =>
    HashByteSeq.hash(day.string() + month + year.string())
  fun eq(that: box->Date): Bool =>
    hash() == that.hash()
  fun ne(that: box->Date): Bool =>
    not this.eq(that)

actor ValueObject
  new create(env: Env) =>
    env.out.print("Value object:")
    let third_of_march = Date(3, "March", 2017)
    let fourth_of_july = Date(4, "July", 2017)
    let new_year1 = Date(31, "December", 2017)
    let new_year2 = Date(31, "December", 2017)

    env.out.print("value: third_of_march == fourth_of_july: " + (third_of_march == fourth_of_july).string())
    env.out.print("value: new_year1 == new_year2: " + (new_year1 == new_year2).string())
    env.out.print("object: new_year1 is new_year2: " + (new_year1 is new_year2).string())

    let date1: DateTuple = (3, "March", 2017)
    let date2: DateTuple = (3, "July", 2017)
    let date2': DateTuple = (3, "July", 2017)

    env.out.print("object: date1 is date2: " + (date1 is date2).string())
    env.out.print("object: date2 is date2': " + (date2 is date2').string())