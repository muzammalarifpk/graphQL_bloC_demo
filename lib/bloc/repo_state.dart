import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

@immutable
abstract class RepoState extends Equatable {
  @override
  List<Object> get props => [];
}

class RepoInitial extends RepoState {}

class RepoLoading extends RepoState {}

class RepoLoaded extends RepoState {
  final List<dynamic> repositories;

  RepoLoaded(this.repositories);

  @override
  List<Object> get props => [repositories];
}

class RepoError extends RepoState {
  final String message;

  RepoError(this.message);

  @override
  List<Object> get props => [message];
}
