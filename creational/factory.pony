trait SimpleConnection
    fun getName(): String
    fun executeQuery(query: String)

class SimpleMysqlConnection is SimpleConnection
    let _env : Env 

    new create(env: Env) => _env = env

    fun getName(): String => "SimpleMysqlConnection"
    fun executeQuery(query: String) =>
        _env.out.print("Executing the query " + query + " The MySql way.")

class SimplePgsqlConnection is SimpleConnection
    let _env : Env 

    new create(env: Env) => _env = env

    fun getName(): String => "SimplePgsqlConnection"
    fun executeQuery(query: String) =>
        _env.out.print("Executing the query " + query + " The PgSql way.")

trait DataBaseClient
    fun executeQuery(query: String) =>
        let connection: SimpleConnection = _connect()
        connection.executeQuery(query)
    fun _connect(): SimpleConnection

class MySqlClient is DataBaseClient
    let _env: Env
    new create(env: Env) => _env = env 
    fun _connect(): SimpleConnection => SimpleMysqlConnection(_env)

class PgSqlClient is DataBaseClient
    let _env: Env
    new create(env: Env) => _env = env 
    fun _connect(): SimpleConnection => SimplePgsqlConnection(_env)

actor Factory
    new create(env: Env) =>
        env.out.print("Factory:")
        let clientMySql: DataBaseClient = MySqlClient(env)
        let clientPgSql: DataBaseClient = PgSqlClient(env)
        env.out.print("Factory:")
        clientMySql.executeQuery("SELECT * FROM users")
        clientPgSql.executeQuery("SELECT * FROM employees")