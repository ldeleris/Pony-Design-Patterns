class Money
  let amount: U64
  
  new create(amount': U64) =>
    amount = amount'
  
  fun string(): String iso^ =>
    amount.string()

type OptDispenser is (None | Dispenser)

trait Dispenser
  fun amount(): U64
  fun ref next(): OptDispenser
  fun ref dispense(env: Env, money: Money) =>
    if (money.amount >= amount()) then
      let notes: U64 = money.amount / amount()
      let left: U64 = money.amount % amount()
      env.out.print("Dispensing " + notes.string() + " note/s of " + amount().string())
      if left > 0 then 
        match next()
        | None => env.out.print("")
        | let n: Dispenser => n.dispense(env, Money(left))
        end
      end
    else
      match next()
      | None => env.out.print("")
      | let n: Dispenser => n.dispense(env, money)
      end
    end

class Dispenser50 is Dispenser
  let d: OptDispenser
  new create(d': OptDispenser) => d = d'
  fun ref next(): OptDispenser => d
  fun amount(): U64 => 50

class Dispenser20 is Dispenser
  let d: OptDispenser
  new create(d': OptDispenser) => d = d'
  fun ref next(): OptDispenser => d
  fun amount(): U64 => 20

class Dispenser10 is Dispenser
  let d: OptDispenser
  new create(d': OptDispenser) => d = d'
  fun ref next(): OptDispenser => d
  fun amount(): U64 => 10

class Dispenser5 is Dispenser
  let d: OptDispenser
  new create(d': OptDispenser) => d = d'
  fun ref next(): OptDispenser => d
  fun amount(): U64 => 5

class ATM
  let _dispenser: Dispenser
  let _env: Env

  new create(env: Env) =>
    _env = env
    let d1 = Dispenser5(None)
    let d2 = Dispenser10(d1)
    let d3 = Dispenser20(d2)
    _dispenser = Dispenser50(d3)

  fun ref request_money(money: Money) =>
    if (money.amount % 5) != 0 then
      _env.out.print("The smallest nominal is 5 and we cannot satisfy your request.")
    else
      _dispenser.dispense(_env, money)
    end



actor ChainOfResponsability
  new create(env: Env) =>
    env.out.print("Chain of Responsability:")
    let atm = ATM(env)
    env.out.print("Request 100:")
    atm.request_money(Money(100))
    env.out.print("Request 85:")
    atm.request_money(Money(85))
    env.out.print("Request 4:")
    atm.request_money(Money(4))