interface Key
  fun open(): String
  fun close(): String

class CarDoorKey is Key
  fun open(): String =>
    "I'm pushing down the button of remote control."
  fun close(): String =>
    "I'm pushing up the button of remote control."  

class HouseDoorKey is Key
  fun open(): String =>
    "I'm turning the key in the right side."
  fun close(): String =>
    "I'm turning the key in the left side."  

class _Door
  let _key: Key

  new create(key: Key) =>
    _key = key

  fun open_the_door(): String  =>
    _key.open()

  fun close_the_door(): String =>
    _key.close()

  fun prevent_owner(): String =>
    "Hi Owner! You have a guest."

class HouseOneDoor
  let _door: _Door

  new create(key: Key) =>
    _door = _Door(key)

  fun enter(): String =>
    _door.prevent_owner() + "\n" + _door.open_the_door()

  fun leave(): String =>
    _door.close_the_door()     

class CarOneDoor
  let _door: _Door

  new create(key: Key) =>
    _door = _Door(key)

  fun enter(): String =>
    _door.open_the_door() + " You can park the car."

  fun leave(): String =>
    _door.close_the_door() + " Have a good trip." 

actor Bridge
  new create(env: Env) =>
    env.out.print("Bridge:")
    let house: HouseOneDoor = HouseOneDoor(HouseDoorKey)
    env.out.print(house.enter())
    env.out.print(house.leave())
    let garage: CarOneDoor = CarOneDoor(CarDoorKey)
    env.out.print(garage.enter())
    env.out.print(garage.leave())