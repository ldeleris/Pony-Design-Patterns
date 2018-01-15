// Only works whith debug option!!
trait State[T]
  fun press(context: T)

class Playing is State[MediaPlayer]
  let _env: Env

  new create(env: Env) => _env = env

  fun press(context: MediaPlayer) =>
    _env.out.print("Pressing pause.")
    context.set_state(Paused(_env))

class Paused is State[MediaPlayer]
  let _env: Env

  new create(env: Env) => _env = env

  fun press(context: MediaPlayer) =>
    _env.out.print("Pressing play.")
    context.set_state(Playing(_env))

class MediaPlayer
  var _state: State[MediaPlayer]

  new create(env: Env) =>
    _state = Paused(env)
  
  fun ref press_button() =>
    _state.press(this)

  fun ref set_state(state: State[MediaPlayer]) =>
    _state = state


actor StateDesign
  new create(env: Env) =>
    env.out.print("State:")
    let player: MediaPlayer = MediaPlayer(env)
    player.press_button()
    player.press_button()
    player.press_button()
    player.press_button()