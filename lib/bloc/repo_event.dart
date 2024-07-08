import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RepoEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchRepos extends RepoEvent {
  final String language;

  FetchRepos({this.language = 'JavaScript'});

  @override
  List<Object> get props => [language];
}
