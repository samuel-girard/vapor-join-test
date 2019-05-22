import FluentPostgreSQL
import Vapor

/// Called before your application initializes.
public func configure(_ config: inout Config, _ env: inout Environment, _ services: inout Services) throws {
    // Register providers first
    try services.register(FluentPostgreSQLProvider())

    // Register routes to the router
    let router = EngineRouter.default()
    try routes(router)
    services.register(router, as: Router.self)

    // Register middleware
    var middlewares = MiddlewareConfig() // Create _empty_ middleware config
    // middlewares.use(FileMiddleware.self) // Serves files from `Public/` directory
    middlewares.use(ErrorMiddleware.self) // Catches errors and converts to HTTP response
    services.register(middlewares)

    // Register the configured SQLite database to the database config.
    let pgsql = PostgreSQLDatabase(config: PostgreSQLDatabaseConfig(hostname: "localhost", port: 8765, username: "postgres"))
    var databases = DatabasesConfig()
    databases.add(database: pgsql, as: .psql)
    services.register(databases)

    // Configure migrations
    var migrations = MigrationConfig()
    migrations.add(model: Todo.self, database: .psql)
    migrations.add(model: User.self, database: .psql)
    migrations.add(model: UserTodo.self, database: .psql)
    
    migrations.add(migration: UserMigration.self, database: .psql)
    migrations.add(migration: TodoMigration.self, database: .psql)
    migrations.add(migration: UserTodoMigration.self, database: .psql)
    
    services.register(migrations)
}
