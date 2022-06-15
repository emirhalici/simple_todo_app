class Queries {
  static const String addQuery = r'''
    mutation($is_done: Boolean, $priority: Int, $todo: String, $user: uuid) {
      insert_todos_one(object: {is_done: $is_done, priority: $priority, todo: $todo, user: $user}) {
          created_at
          id
          is_done
          priority
          todo
          user
          }
    }
  ''';

  static const String editQuery = r'''
    mutation EditTodo($_eq: Int, $is_done: Boolean, $priority: Int, $todo: String) {
      update_todos(_set: {todo: $todo, priority: $priority, is_done: $is_done}, where: {id: {_eq: $_eq}}) {
        returning {
          created_at
          id
          is_done
          priority
          todo
          user
        }
      }
    }
  ''';

  static const String deleteQuery = r'''
    mutation DeleteTodo($_eq: Int) {
      delete_todos(where: {id: {_eq: $_eq}}) {
        returning {
          id
        }
      }
    }
  ''';

  static const String getAllTodosAscQuery = r'''
    query {
      todos(order_by: {created_at: asc}) {
        id
        priority
        todo
        created_at
        is_done
        user
        }
    }
  ''';
}
