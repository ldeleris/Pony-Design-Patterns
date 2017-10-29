class Person is Stringable
    let firstName: String
    let lastName: String
    let age: U64

    new create(builder: PersonBuilder) =>
        firstName = builder.firstName
        lastName = builder.lastName
        age = builder.age

    fun string(): String iso^ =>
        (firstName + " " + lastName + ", " + age.string()).string()

class PersonBuilder
    var firstName: String = ""
    var lastName: String = ""
    var age: U64 = 0

    fun ref setFirstName(firstName': String): PersonBuilder =>
        firstName = firstName'
        this
    fun ref setLastName(lastName': String): PersonBuilder =>
        lastName = lastName'
        this
    fun ref setAge(age': U64): PersonBuilder =>
        age = age'
        this
    fun ref build(): Person => Person(this)

actor Builder
    new create(env: Env) =>
        env.out.print("Builder")
        let person: Person = PersonBuilder
            .setFirstName("Laurent")
            .setLastName("Deleris")
            .setAge(50)
            .build()
        env.out.print(person.string())



