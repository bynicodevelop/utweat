part of 'list_content_bloc.dart';

abstract class ListContentState extends Equatable {
  const ListContentState();

  @override
  List<Object> get props => [];
}

class ListContentInitialState extends ListContentState {
  final int refresh;
  final List<ContentModel> contents;

  const ListContentInitialState({
    required this.refresh,
    required this.contents,
  });

  @override
  List<Object> get props => [
        refresh,
        contents,
      ];
}
