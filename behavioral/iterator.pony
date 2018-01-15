use "collections"

class Student
  let name: String
  let age: U64

  new create(name': String, age': U64) =>
    name = name'
    age = age'

  fun string(): String iso^ =>
    ("Student(" + name.string() + ", " + age.string() + ")").string()

class StudentIterator is Iterator[Student]
  let students: Array[Student]
  var current_pos: USize = 0

  new create(students': Array[Student]) =>
    students = students'

  fun ref has_next(): Bool =>
    current_pos < students.size()

  fun ref next(): Student ? =>
    let result = students(current_pos)?
    current_pos = current_pos + 1
    result

class ClassRoom
  let students: List[Student] = List[Student]()

  fun ref add(student: Student) =>
    students.push(student)
/*
  fun iterator(): Iterator[Student] =>
    let tmp: Array[Student] = students.fold[Array[Student]]( {(acc: Array[Student], x: Student): Array[Student] => 
      acc.push(x)
      acc }, Array[Student]())
    StudentIterator(tmp)
*/

