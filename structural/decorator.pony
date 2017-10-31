trait Dessert
    fun get_libelle(): String 
    fun get_prix(): F64 
    fun string(): String =>  get_libelle() + ": " + get_prix().string()

class _ClassDessert is Dessert 
    let _libelle: String
    let _prix: F64
    new create(libelle: String, prix: F64) =>
        _libelle = libelle
        _prix = prix
    fun get_libelle(): String => _libelle
    fun get_prix(): F64 => _prix
    fun string(): String =>
        _libelle + " = " + _prix.string()

primitive Gauffre is Dessert
    fun apply(): _ClassDessert => _ClassDessert(get_libelle(), get_prix())
    fun get_libelle(): String => "Gauffre"
    fun get_prix(): F64 => 1.5
    fun string(): String => this.string()

primitive Crepe is Dessert
    fun apply(): _ClassDessert => _ClassDessert(get_libelle(), get_prix())
    fun get_libelle(): String => "Crepe"
    fun get_prix(): F64 => 1.0
    fun string(): String => this.string()

class Chantilly is Dessert
    let _dessert: Dessert
    new create(dessert: Dessert) =>
        _dessert = dessert
    fun get_libelle(): String => _dessert.get_libelle() + " Chantilly"
    fun get_prix(): F64 => _dessert.get_prix() + 0.3

class Chocolat is Dessert
    let _dessert: Dessert
    new create(dessert: Dessert) =>
        _dessert = dessert
    fun get_libelle(): String => _dessert.get_libelle() + " Chocolat"
    fun get_prix(): F64 => _dessert.get_prix() + 0.20

class Caramel is Dessert
    let _dessert: Dessert
    new create(dessert: Dessert) =>
        _dessert = dessert
    fun get_libelle(): String => _dessert.get_libelle() + " Caramel"
    fun get_prix(): F64 => _dessert.get_prix() + 0.10

actor Decorator
    new create(env: Env) =>
        env.out.print("Decorator:")
        let d: Dessert = Gauffre()
        let d1: Dessert = Chocolat(d)
        env.out.print("\t" + d1.string())
        let c: Dessert = Crepe()
        let c1: Dessert = Chantilly(c)
        let c2: Dessert = Chocolat(c1)
        env.out.print("\t" + c2.string())
        let e: Dessert =  Chantilly(Chocolat(Caramel(Crepe())))
        env.out.print("\t" + e.string())
