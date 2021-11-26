part of 'delete_content_bloc.dart';

abstract class DeleteContentEvent extends Equatable {
  const DeleteContentEvent();

  @override
  List<Object> get props => [];
}

class OnDeleteContentEvent extends DeleteContentEvent {
  final String uid;

  const OnDeleteContentEvent({
    required this.uid,
  });

  @override
  List<Object> get props => [
        uid,
      ];
}
