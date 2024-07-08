import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'bloc/repo_bloc.dart';
import 'screens/main_screen.dart';
import 'graphql/client.dart';

void main() async {
  // Ensure that all bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize the GraphQL client
  await initHiveForFlutter(); // You may need to replace this with your GraphQL client initialization method

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final GraphQLClient graphQLClient = GraphQLClientProvider.client;

    return GraphQLProvider(
      client: ValueNotifier(graphQLClient),
      child: CacheProvider(
        child: MultiBlocProvider(
          providers: [
            BlocProvider<RepoBloc>(
              create: (context) => RepoBloc(graphQLClient), // Pass the GraphQL client here
            ),
          ],
          child: MaterialApp(
            title: 'GitHub Repositories',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            home: MainScreen(),
          ),
        ),
      ),
    );
  }
}
