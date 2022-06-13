import 'package:graphql/client.dart';
import 'package:simple_todo_app/models/todo_model.dart';

class DatabaseHelper {
  GraphQLClient getClient() {
    final httpLink = HttpLink('https://my-todo-app-hasura.herokuapp.com/v1/graphql');
    return GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(),
    );
  }

  Future<Map<String, dynamic>?> runQuery(GraphQLClient client, String query) async {
    final QueryOptions options = QueryOptions(document: gql(query));
    final QueryResult result = await client.query(options);

    if (result.hasException) {
      throw 'GraphQL Query Exception: ${result.exception.toString()}';
    }

    return result.data;
  }

  Future<Map<String, dynamic>?> runCreateMutation(GraphQLClient client, TodoModel todoModel) async {
    const String addQuery = r'''
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
    final MutationOptions options = MutationOptions(document: gql(addQuery), variables: <String, dynamic>{
      'is_done': todoModel.isDone,
      'todo': todoModel.todo,
      'priority': todoModel.priority,
      'user': '07c42a78-d85f-46e8-a98b-2c3d45c3b52b',
    });
    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      throw 'GraphQL Mutation Exception ${result.exception.toString()}';
    }

    return result.data;
  }

  Future<Map<String, dynamic>?> runEditMutation(GraphQLClient client, TodoModel todoModel) async {
    const String editQuery = r'''
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

    final MutationOptions options = MutationOptions(document: gql(editQuery), variables: <String, dynamic>{
      '_eq': todoModel.id,
      'is_done': todoModel.isDone,
      'priority': todoModel.priority,
      'todo': todoModel.todo,
    });
    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      throw 'GraphQL Edit Mutation Exception ${result.exception.toString()}';
    }

    return result.data;
  }

  Future<Map<String, dynamic>?> runDeleteMutation(GraphQLClient client, TodoModel todoModel) async {
    const String deleteQuery = r'''
    mutation DeleteTodo($_eq: Int) {
      delete_todos(where: {id: {_eq: $_eq}}) {
        returning {
          id
        }
      }
    }
    ''';

    final MutationOptions options = MutationOptions(
      document: gql(deleteQuery),
      variables: <String, dynamic>{
        '_eq': todoModel.id,
      },
    );
    final QueryResult result = await client.mutate(options);

    if (result.hasException) {
      throw 'GraphQL Delete Mutation Exception ${result.exception.toString()}';
    }

    return result.data;
  }
}
