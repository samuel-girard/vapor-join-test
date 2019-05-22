import Vapor
import FluentPostgreSQL

struct UserTodo: PostgreSQLPivot {
    typealias Left = User
    typealias Right = Todo
    
    static var leftIDKey: LeftIDKey = \.userId
    static var rightIDKey: RightIDKey = \.todoId
    
    var id: Int?
    var userId: Int
    var todoId: Int
    
    init(userId: Int, todoId: Int) {
        print("UserTodo with user " + String(userId) + " and todo " + String(todoId))
        self.userId = userId
        self.todoId = todoId
    }
}

extension UserTodo: Migration {
    static func prepare(on conn: PostgreSQLConnection) -> Future<Void> {
        return PostgreSQLDatabase.create(UserTodo.self, on: conn) { builder in
            builder.field(for: \.id, isIdentifier: true)
            builder.field(for: \.userId)
            builder.field(for: \.todoId)
            builder.unique(on: \.userId, \.todoId)
            builder.reference(from: \.userId, to: \User.id)
            builder.reference(from: \.todoId, to: \Todo.id)
        }
    }
}
