import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:utweat/models/content_model.dart';
import 'package:utweat/respositories/content_repository.dart';

part 'list_content_event.dart';
part 'list_content_state.dart';

class ListContentBloc extends Bloc<ListContentEvent, ListContentState> {
  final ContentRepository contentRepository;

  ListContentBloc({
    required this.contentRepository,
  }) : super(const ListContentInitialState(
          refresh: 0,
          contents: [],
        )) {
    contentRepository.contents.listen((contents) {
      print(contents);

      add(_OnLoadedContentEvent(
        refresh: DateTime.now().microsecondsSinceEpoch,
        contents: contents,
      ));
    });

    on<OnLoadedContentEvent>((event, emit) async {
      await contentRepository.load();

      List<ContentModel> contents =
          await contentRepository.contents.asyncMap((content) {
        return content;
      }).first;

      add(
        _OnLoadedContentEvent(
          refresh: DateTime.now().microsecondsSinceEpoch,
          contents: contents,
        ),
      );
    });

    on<_OnLoadedContentEvent>((event, emit) {
      emit(ListContentInitialState(
        refresh: DateTime.now().microsecondsSinceEpoch,
        contents: event.contents,
      ));
    });
  }
}
