part of 'delete_content_bloc.dart';

abstract class DeleteContentState extends Equatable {
  const DeleteContentState();

  @override
  List<Object> get props => [];
}

class DeleteContentInitial extends DeleteContentState {}

class DeleteContentLoadingState extends DeleteContentState {}

class DeleteContentSuccessState extends DeleteContentState {}

class DeleteContentFailureState extends DeleteContentState {
  final String error;

  const DeleteContentFailureState(this.error);

  @override
  List<Object> get props => [error];
}
