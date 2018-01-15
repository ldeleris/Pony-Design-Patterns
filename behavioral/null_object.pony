use "collections"
use "random"
use mydelay = "time"
use "lib:Kernel32"

interface OptMessage
  fun string(): String iso^ 

class NoMessage is OptMessage

  new iso create() => None

  fun string(): String iso^ =>
    "none".string()

class Message is OptMessage
  let number: U64

  new iso create(number': U64) =>
    number = number'

  fun string(): String iso^ =>
    ("This is a message whith number: " + number.string()).string()

actor DataGenerator
  let max_val: U64 = 100_000_000
  let max_time: U64 = 1_500
  var _is_stop: Bool = false
  var _queue: List[U64] iso =  recover List[U64](0) end
  let d: U64 = 100
  let rand: Rand

  new create() =>
    rand = Rand(100)

  be step() =>   
    let timers = mydelay.Timers 
    let throw = match (rand.next() * 1000)
    | let t: U64 if t < max_time => t
    else
      max_time
    end
    //@Sleep[I64](U64(throw))
    /*
    let timer = mydelay.Timer(Notify, throw * 1_000_000_000)
    timers(consume timer)
    */
    _queue.push(rand.next())
    if (not _is_stop) then step() end

  be run() =>
    step()

  be get_message(receiver: NullObject tag) =>
    let message: OptMessage iso = 

      match try _queue.pop()? else None end
      | let n: U64 => Message(n)
      | None => NoMessage
      end
        
    receiver.receive(consume message)

  be request_stop() =>
    _is_stop = true


class Notify is mydelay.TimerNotify

  fun ref apply(timer: mydelay.Timer, count: U64): Bool =>
    false

actor NullObject
  let times_to_try: U64 = 10
  let max_time: U64 = 1_000
  var _env: Env
  var _message: OptMessage = NoMessage
  let generator: DataGenerator = DataGenerator
  let rand: Rand = Rand()
  var i: U64 = 0

  new create(env: Env) =>
    _env = env
    env.out.print("Null Object:")
    generator.run()
    step()

  be step() =>  
         
    let throw = match (rand.next() * 100)
    | let t: U64 if t < max_time => t
    else
      max_time
    end
    
    //@Sleep[I64](throw)
    /*
    let timers = mydelay.Timers
    let timer = mydelay.Timer(Notify, throw * 1_000_000_000)
    timers(consume timer)
    */
    _env.out.print("Getting next message...")
    generator.get_message(this)
    //generator.get_message(recover {(x:OptMessage) => _message = x } end)
    _env.out.print(_message.string())

    i = i + 1
    if i < times_to_try then step() else stop() end

be stop() =>  
  _env.out.write("end...")
  generator.request_stop()
  _env.out.write("stop...")
  _env.out.print("quit...")


  be receive(message: OptMessage iso) =>
    _message =  consume message 