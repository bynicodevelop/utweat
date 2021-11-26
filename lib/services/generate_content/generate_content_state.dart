part of 'generate_content_bloc.dart';

abstract class GenerateContentState extends Equatable {
  const GenerateContentState();

  @override
  List<Object> get props => [];
}

class GenerateContentInitial extends GenerateContentState {}

class GenerateContentLoadingState extends GenerateContentState {}

class GenerateContentLoadedState extends GenerateContentState {
  final String content;

  const GenerateContentLoadedState({
    required this.content,
  });

  @override
  List<Object> get props => [
        content,
      ];
}

class GenerateContentFailureState extends GenerateContentState {
  final String error;

  const GenerateContentFailureState({
    required this.error,
  });

  @override
  List<Object> get props => [
        error,
      ];
}
