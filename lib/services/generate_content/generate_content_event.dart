part of 'generate_content_bloc.dart';

abstract class GenerateContentEvent extends Equatable {
  const GenerateContentEvent();

  @override
  List<Object> get props => [];
}

class OnGenerateContentEvent extends GenerateContentEvent {
  final String uid;

  const OnGenerateContentEvent({
    required this.uid,
  });

  @override
  List<Object> get props => [
        uid,
      ];
}
