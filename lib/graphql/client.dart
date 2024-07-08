import 'package:graphql_flutter/graphql_flutter.dart';

class GraphQLClientProvider {
  static final HttpLink httpLink = HttpLink(
    'https://api.github.com/graphql',
    defaultHeaders: {
      'Authorization': 'Bearer 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', // Replace with your token
    },
  );

  static final GraphQLClient client = GraphQLClient(
    link: httpLink,
    cache: GraphQLCache(store: InMemoryStore()),
  );
}
