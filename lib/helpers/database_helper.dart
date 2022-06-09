import 'package:graphql/client.dart';

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
}
