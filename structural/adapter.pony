
class Logger
    let env: Env
    new create(env': Env) => env = env'
    fun log(message: String, severity: String) =>
        env.out.print("["+severity+"] "+message)

trait Log
    fun info(msg: String)
    fun debug(msg: String)
    fun warning(msg: String)
    fun err(msg: String)

class AppLogger is Log
    let env: Env
    embed logger: Logger
    new create(env': Env) => 
        env = env'
        logger = Logger(env)
    fun info(msg: String) => logger.log(msg, "INFO")
    fun debug(msg: String) => logger.log(msg, "DEBUG")
    fun warning(msg: String) => logger.log(msg, "WARNING")
    fun err(msg: String) => logger.log(msg, "ERROR")

actor Adapter
    new create(env: Env) =>
        env.out.print("Adapter:")
        let logger = AppLogger(env)
        logger.info("This is an info message")
        logger.info("Debug something here")
        logger.err("Show an error message")
        logger.warning("About to finish")
        logger.info("Bye!")