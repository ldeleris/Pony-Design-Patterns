trait Animal is Stringable
    fun string(): String iso^
class Bird is (Animal & Stringable)
    fun string(): String iso^ => "Bird".string()
class Mammal is (Animal & Stringable)
    fun string(): String iso^ => "Mammal".string()
class Fish is (Animal & Stringable)
    fun string(): String iso^ => "Fish".string()
class Unknown is (Animal & Stringable)
    fun string(): String iso^ => "Unknown animal".string()

primitive AnimalStatic
    fun apply(animal: String): Animal? =>
        match animal 
            | "bird" => Bird
            | "mammal" => Mammal
            | "fish" => Fish
            else
                error
        end

actor Static
    new create(env: Env) =>
        env.out.print("Static:")
        var animal: Animal = try AnimalStatic("bird")? else  Unknown end
        env.out.print(animal.string())
        animal = try AnimalStatic("homme")? else Unknown end
        env.out.print(animal.string())

