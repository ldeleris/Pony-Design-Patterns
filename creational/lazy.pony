""" 
    Lazy Initialization
"""
use "lib:Kernel32"

class Circle 
    let basicPi: F64 = 3.14
    let _delay: U32 = 1000
    var _isLoaded: Bool = false
    var _precisePi: F64 = 0
    
    fun ref precisePi(): F64 =>
        _isLoaded = _isLoaded or _temp() // court circuit
        _precisePi
    
    fun ref _temp(): Bool => // chargement simulé avec un petit délais
        @Sleep[I64](_delay)
        _isLoaded = true
        _precisePi = 3.1415926535
        true

    fun ref area(radius: F64, precise: Bool): F64 =>
        var pi: F64 = if precise then precisePi() else basicPi end
        pi * radius * radius

class Lazy
    new create(env: Env) =>
        env.out.print("Lazy")
        let obj: Circle = Circle
        env.out.print(" The basic area for a circle with radius 2.5 is " +
            obj.area(2.5, false).string())
        env.out.print(" The precise area for a circle with radius 2.5 is " +
            obj.area(2.5, true).string())
        env.out.print(" The basic area for a circle with radius 6.78 is " +
            obj.area(6.78, false).string())
        env.out.print(" The precise area for a circle with radius 6.78 is " +
            obj.area(6.78, true).string())
        env.out.print(" The precise area for a circle with radius 6.78 is " +
            obj.area(6.78, true).string())


