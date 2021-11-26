part of 'add_content_bloc.dart';

abstract class AddContentState extends Equatable {
  const AddContentState();

  @override
  List<Object> get props => [];
}

class AddContentInitial extends AddContentState {}

class AddContentLoading extends AddContentState {}

class AddContentCreated extends AddContentState {}

class AddContentFailure extends AddContentState {
  final String error;

  const AddContentFailure(
    this.error,
  );

  @override
  List<Object> get props => [
        error,
      ];
}
