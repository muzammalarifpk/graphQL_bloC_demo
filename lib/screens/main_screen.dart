import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/repo_bloc.dart';
import '../bloc/repo_event.dart';
import '../bloc/repo_state.dart';

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String selectedLanguage = 'JavaScript';

  @override
  void initState() {
    super.initState();
    // Fetch trending repositories on app startup
    context.read<RepoBloc>().add(FetchRepos(language: selectedLanguage));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GitHub Repositories'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: selectedLanguage,
              onChanged: (String? newValue) {
                if (newValue != null) {
                  setState(() {
                    selectedLanguage = newValue;
                  });
                  // Fetch repositories for the selected language
                  context.read<RepoBloc>().add(FetchRepos(language: selectedLanguage));
                }
              },
              items: <String>['JavaScript', 'Python', 'Java', 'C++', 'xyz', 'Dart']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          Expanded(
            child: BlocBuilder<RepoBloc, RepoState>(
              builder: (context, state) {
                if (state is RepoInitial) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is RepoLoading) {
                  return Center(child: CircularProgressIndicator());
                } else if (state is RepoLoaded) {
                  if (state.repositories.isEmpty) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('No repositories found for the selected language.'),
                          SizedBox(height: 20),
                          ElevatedButton(
                            onPressed: () {
                              // Retry fetching repositories
                              context.read<RepoBloc>().add(FetchRepos(language: selectedLanguage));
                            },
                            child: Text('Retry'),
                          ),
                        ],
                      ),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: state.repositories.length,
                      itemBuilder: (context, index) {
                        final repo = state.repositories[index]['node'];
                        return ListTile(
                          title: Text(repo['name']),
                          subtitle: Text(repo['description'] ?? 'No description'),
                          trailing: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('⭐ ${repo['stargazerCount']}'),
                              const SizedBox(height: 5,),
                              Text(repo['primaryLanguage']['name'] ?? 'No Language',  textAlign: TextAlign.start,),
                            ],
                          ),
                        );
                      },
                    );
                  }
                } else if (state is RepoError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Error: ${state.message}'),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            // Retry fetching repositories
                            context.read<RepoBloc>().add(FetchRepos(language: selectedLanguage));
                          },
                          child: Text('Retry'),
                        ),
                      ],
                    ),
                  );
                } else {
                  return Center(child: Text('Unknown state'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
