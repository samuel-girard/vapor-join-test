import FluentPostgreSQL
import Vapor
import Crypto

struct UserMigration: PostgreSQLMigration {
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        let users = [
            "Pierre",
            "Sophie",
        ]
        var futures: [Future<User>] = []
        for name in users {
            futures.append(User(id: nil, name: name).save(on: connection))
        }
        return futures.flatten(on: connection)
            .transform(to: ())
    }
    static func revert(on connection: PostgreSQLConnection) -> Future<Void> {
        return .done(on: connection)
    }
}
