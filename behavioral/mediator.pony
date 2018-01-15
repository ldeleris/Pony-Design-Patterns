use "collections"

trait Notifiable
  fun notify(env: Env, message: String)

class StudentM is Notifiable
  let name: String
  let age: U64

  new create(name': String, age': U64) =>
    name = name'
    age = age'

  fun string(): String iso^ =>
    ("Student(" + name + ", " + age.string() + ")").string()

  fun notify(env: Env, message: String) =>
    env.out.print("Student " + name + " was notified with message: '" + message + "'.")

  // (Hashable & Equatable[Date]) for == et !=
  fun hash(): U64 =>
    //HashByteSeq.hash(day.string() + month + year.string())
    var h: U64 = 17 + HashByteSeq.hash(name)
    h = (h * 31) + HashByteSeq.hash(age.string())
    h
  
  fun eq(that: box->StudentM): Bool =>
    hash() == that.hash()
  fun ne(that: box->StudentM): Bool =>
    not this.eq(that)

class Group
  let name: String

  new create(name': String) => name = name'

  fun string(): String iso^ =>
    ("Group(" + name + ")").string()

  // (Hashable & Equatable[Date]) for == et !=
  fun hash(): U64 =>
    //HashByteSeq.hash(day.string() + month + year.string())
    var h: U64 = 17 + HashByteSeq.hash(name)
    h
  
  fun eq(that: box->Group): Bool =>
    hash() == that.hash()
  fun ne(that: box->Group): Bool =>
    not this.eq(that)

trait Mediator
  fun ref add_student_to_group(student: StudentM, group: Group)
  fun ref is_student_in_group(student: StudentM, group: Group): Bool
  fun ref remove_student_from_group(student: StudentM, group: Group)
  fun ref get_students_in_group(group: Group): Set[StudentM]
  fun ref get_group_for_student(student: StudentM): Set[Group]
  fun ref notify_students_in_group(group: Group, message: String)


class School is Mediator
  let env: Env
  let students_to_groups: Map[StudentM, Set[Group]] = Map[StudentM, Set[Group]]()
  let groups_to_students: Map[Group, Set[StudentM]] = Map[Group, Set[StudentM]]()

  new create(env': Env) => env = env'

  fun ref add_student_to_group(student: StudentM, group: Group) =>
    let groups' = students_to_groups.get_or_else(student, Set[Group]())
    students_to_groups.update(student, groups'.add(group))
    let students' = groups_to_students.get_or_else(group, Set[StudentM]())
    groups_to_students.update(group, students'.add(student))

  fun ref is_student_in_group(student: StudentM, group: Group): Bool =>
    students_to_groups.get_or_else(student, Set[Group]()).contains(group) and
    groups_to_students.get_or_else(group, Set[StudentM]()).contains(student)

  fun ref get_students_in_group(group: Group): Set[StudentM] =>
    groups_to_students.get_or_else(group, Set[StudentM]())

  fun ref get_group_for_student(student: StudentM): Set[Group] =>
    students_to_groups.get_or_else(student, Set[Group]())

  fun ref remove_student_from_group(student: StudentM, group: Group) =>
    let groups' = students_to_groups.get_or_else(student, Set[Group]())
    students_to_groups.update(student, groups'.sub(group))
    let students' = groups_to_students.get_or_else(group, Set[StudentM]())
    groups_to_students.update(group, students'.sub(student))

  fun ref notify_students_in_group(group: Group, message: String) =>
    let students = groups_to_students.get_or_else(group, Set[StudentM]())
    for s in students.values() do
      s.notify(env, message)
    end


actor MediatorDesign
  new create(env: Env) =>
    env.out.print("Mediator:")
    let school: School ref = School(env)
    let student1 = StudentM("Yvan", 26)
    let student2 = StudentM("Maria", 26)
    let student3 = StudentM("John", 25)
    let group1 = Group("Pony design patterns")
    let group2 = Group("Databases")
    let group3 = Group("Concurent computing")

    school.add_student_to_group(student1, group1)
    school.add_student_to_group(student1, group2)
    school.add_student_to_group(student1, group3)

    school.add_student_to_group(student2, group1)
    school.add_student_to_group(student2, group3)

    school.add_student_to_group(student3, group1)
    school.add_student_to_group(student3, group2)

    school.notify_students_in_group(group1, "Pony is amazing!")

    show_groups(env, student3, school)
    school.remove_student_from_group(student3, group2)
    show_groups(env, student3, school)
    
    show_students(env, group1, school)


  fun show_groups(env: Env, student: StudentM, school: School) =>
    env.out.write(student.string() + " is in groups: ")
    let groups: Set[Group] = school.get_group_for_student(student)
    for g in groups.values() do
      env.out.write(g.string() + ", ")
    end
    env.out.print("")

  fun show_students(env: Env, group: Group, school: School) =>
    env.out.write("Students in " + group.string() + " are: ")
    let students: Set[StudentM] = school.get_students_in_group(group)
    for s in students.values() do
      env.out.write(s.string() + ", ")
    end
    env.out.print("")

  
    
