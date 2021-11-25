part of 'list_content_bloc.dart';

abstract class ListContentEvent extends Equatable {
  const ListContentEvent();

  @override
  List<Object> get props => [];
}

class OnLoadedContentEvent extends ListContentEvent {
  final List<ContentModel> contents;

  const OnLoadedContentEvent({
    required this.contents,
  });

  @override
  List<Object> get props => [
        contents,
      ];
}
