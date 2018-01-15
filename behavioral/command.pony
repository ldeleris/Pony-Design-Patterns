use "collections"

class Robot
  let env: Env

  new create(env': Env) => env = env'
  fun cleanup() => env.out.print("Cleaning up.")
  fun pour_juice() => env.out.print("Pouring juice")
  fun make_sandwich() => env.out.print("Making a sandwich.")
  fun string(): String iso^ => "robot".string()

trait RobotCommand
  fun execute() 
  fun string(): String iso^ 

class MakeSandwichCommand is RobotCommand
  let _robot: Robot

  new create(robot: Robot) => _robot = robot

  fun execute() => _robot.make_sandwich()

  fun string(): String iso^ =>
    ("MakeSandwichCommand(" + _robot.string() + "())").string()


 class PourJuiceCommand is RobotCommand
  let _robot: Robot

  new create(robot: Robot) => _robot = robot

  fun execute() => _robot.pour_juice() 

  fun string(): String iso^ =>
    ("PourJuiceCommand(" + _robot.string() + "())").string()

class CleanupCommand is RobotCommand
  let _robot: Robot

  new create(robot: Robot) => _robot = robot

  fun execute() => _robot.cleanup()

  fun string(): String iso^ =>
    ("CleanupCommand(" + _robot.string() + "())").string()

class RobotController
  let history: List[RobotCommand] = List[RobotCommand]()

  fun ref issue_command(command: RobotCommand) =>
    history.push(command)
    command.execute()

  fun show_history(env: Env) ? =>
    for h in Range(0, history.size()) do
      env.out.print(history(h)?.string())
    end

class RobotByNameController
  let history: List[{()}] = List[{()}]()

  fun ref issue_command(command: {()}) =>
    history.push(command)
    command
  
  fun show_history(env: Env) =>
    for h in Range(0, history.size()) do
      //env.out.print(history(h)?.string())
      env.out.print("not implemented!")
    end

actor Command
  new create(env: Env) =>
    env.out.print("Command:")
    let robot = Robot(env)
    let robot_controller: RobotController ref = RobotController

    robot_controller.issue_command(MakeSandwichCommand(robot))
    robot_controller.issue_command(PourJuiceCommand(robot))
    env.out.print("I'm eating and having some juice.")
    robot_controller.issue_command(CleanupCommand(robot))

    env.out.print("Here is what I asked my robot to do:")
    try
      robot_controller.show_history(env)?
    end

/*
    let robot_controller2: RobotByNameController ref = RobotByNameController
    robot_controller2.issue_command((MakeSandwichCommand(robot)).execute())
    robot_controller2.issue_command((PourJuiceCommand(robot)).execute())
    env.out.print("I'm eating and having some juice.")
    robot_controller2.issue_command((CleanupCommand(robot)).execute())
    env.out.print("Here is what I asked my robot to do:")
    robot_controller2.show_history(env)
*/   