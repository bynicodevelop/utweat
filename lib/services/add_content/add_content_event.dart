part of 'add_content_bloc.dart';

abstract class AddContentEvent extends Equatable {
  const AddContentEvent();

  @override
  List<Object> get props => [];
}

class OnCreateNewContentEvent extends AddContentEvent {
  final Map<String, dynamic> content;

  const OnCreateNewContentEvent(
    this.content,
  );

  @override
  List<Object> get props => [
        content,
      ];
}
