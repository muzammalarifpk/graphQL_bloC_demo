import 'package:bloc/bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'repo_event.dart';
import 'repo_state.dart';

class RepoBloc extends Bloc<RepoEvent, RepoState> {
  final GraphQLClient client;

  RepoBloc(this.client) : super(RepoInitial()) {
    on<FetchRepos>((event, emit) async {
      emit(RepoLoading());

      try {
        final queryOptions = QueryOptions(
          document: gql(fetchTrendingRepositories),
          variables: {
            'query': 'language:${event.language} sort:stars-desc',
          },
        );

        final result = await client.query(queryOptions);

        if (result.hasException) {
          emit(RepoError(result.exception.toString()));
        } else {
          final repositories = result.data?['search']['edges'] ?? [];
          emit(RepoLoaded(repositories));
        }
      } catch (e) {
        emit(RepoError(e.toString()));
      }
    });
  }
}

const String fetchTrendingRepositories = r'''
  query FetchTrendingRepositories($query: String!) {
    search(query: $query, type: REPOSITORY, first: 10) {
      edges {
        node {
          ... on Repository {
            name
            description
            stargazerCount
            primaryLanguage {
              name
            }
          }
        }
      }
    }
  }
''';
