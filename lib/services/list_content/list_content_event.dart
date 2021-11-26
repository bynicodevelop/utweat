part of 'list_content_bloc.dart';

abstract class ListContentEvent extends Equatable {
  const ListContentEvent();

  @override
  List<Object> get props => [];
}

class OnLoadedContentEvent extends ListContentEvent {}

class _OnLoadedContentEvent extends ListContentEvent {
  final int refresh;
  final List<ContentModel> contents;

  const _OnLoadedContentEvent({
    required this.refresh,
    required this.contents,
  });

  @override
  List<Object> get props => [
        refresh,
        contents,
      ];
}
