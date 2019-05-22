import FluentPostgreSQL
import Vapor
import Crypto

struct TodoMigration: PostgreSQLMigration {
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        let todos = [
            "Dishes",
            "Chores",
        ]
        var futures: [Future<Todo>] = []
        for title in todos {
            futures.append(Todo(id: nil, title: title).save(on: connection))
        }
        return futures.flatten(on: connection)
            .transform(to: ())
    }
    static func revert(on connection: PostgreSQLConnection) -> Future<Void> {
        return .done(on: connection)
    }
}
