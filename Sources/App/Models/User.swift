import FluentPostgreSQL
import Vapor

/// A registered user, capable of owning todo items.
final class User: PostgreSQLModel {
    /// User's unique identifier.
    /// Can be `nil` if the user has not been saved yet.
    var id: Int?
    
    /// User's full name.
    var name: String
    
    /// Creates a new `User`.
    init(id: Int? = nil, name: String) {
        self.id = id
        self.name = name
    }
}

/// Allows `User` to be used as a Fluent migration.
extension User: Migration {
    /// See `Migration`.
    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        return PostgreSQLDatabase.create(User.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.name)
            builder.unique(on: \.name)
        }
    }
}

/// Allows `User` to be encoded to and decoded from HTTP messages.
extension User: Content { }

extension User: Validatable {
    /// See `Validatable`.
    static func validations() throws -> Validations<User> {
        var validations = Validations(User.self)
        try validations.add(\.name, .alphanumeric && .count(3...))
        return validations
    }
}

extension User {
    var todos: Siblings<User, Todo, UserTodo> {
        return siblings()
    }
}
