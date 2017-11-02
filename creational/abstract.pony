
trait DataBaseConnectorFactory
"""
# Design Pattern abstract factory
"""
    fun connect(): SimpleConnection

class MySqlFactory is DataBaseConnectorFactory
    let _env: Env 
    new create(env: Env) => _env = env 
    fun connect(): SimpleConnection => SimpleMysqlConnection(_env)

class PgSqlFactory is DataBaseConnectorFactory
    let _env: Env 
    new create(env: Env) => _env = env 
    fun connect(): SimpleConnection => SimplePgsqlConnection(_env)

class DataBaseClientFactory
    let _connectorFactory: DataBaseConnectorFactory
    new create(connectorFactory: DataBaseConnectorFactory) =>
        _connectorFactory = connectorFactory
    fun executeQuery(query: String) =>
        let connection = _connectorFactory.connect()
        connection.executeQuery(query)

actor Abstract 
    new create(env: Env) =>
        env.out.print("Abstract:")
        let clientMySqlFactory: DataBaseClientFactory = DataBaseClientFactory(MySqlFactory(env))
        let clientPgSqlFactory: DataBaseClientFactory = DataBaseClientFactory(PgSqlFactory(env))
        env.out.print("Abstract factory:")
        clientMySqlFactory.executeQuery("SELECT * FROM users")
        clientPgSqlFactory.executeQuery("SELECT * FROM employees")        