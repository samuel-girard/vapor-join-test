import FluentPostgreSQL
import Vapor
import Crypto

struct UserTodoMigration: PostgreSQLMigration {
    static func prepare(on connection: PostgreSQLConnection) -> Future<Void> {
        return [
                UserTodo(userId: 1, todoId: 1).save(on: connection),
                UserTodo(userId: 1, todoId: 2).save(on: connection),
                UserTodo(userId: 2, todoId: 2).save(on: connection),
            ]
            .flatten(on: connection)
            .then({ (userTodos) -> EventLoopFuture<[UserTodo]> in
                UserTodo.query(on: connection)
                    .join(\User.id, to: \UserTodo.userId)
                    .join(\Todo.id, to: \UserTodo.todoId)
                    .decode(UserTodo.self)
                    .all()
                    .map({ (uts) -> [UserTodo] in
                        for ut in uts {
                            print(ut)
                        }
                        return uts
                    })
            })
            .transform(to: ())
    }
    static func revert(on connection: PostgreSQLConnection) -> Future<Void> {
        return .done(on: connection)
    }
}
