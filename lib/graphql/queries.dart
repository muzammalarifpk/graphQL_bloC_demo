const String fetchTrendingRepositories = '''
query FetchTrendingRepositories(\$language: String) {
  search(query: "stars:>100", type: REPOSITORY, first: 10) {
    nodes {
      ... on Repository {
        name
        description
        primaryLanguage {
          name
        }
      }
    }
  }
}
''';
