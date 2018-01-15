"""
# Structural design patterns
## Adapter
### Exemple
```pony
use "structural"

actor Main
  new create(env: Env) =>
    env.out.print("Adapter:")
    let logger = AppLogger(env)
    logger.info("This is an info message")
    logger.info("Debug something here")
    logger.err("Show an error message")
    logger.warning("About to finish")
    logger.info("Bye!")
```
"""