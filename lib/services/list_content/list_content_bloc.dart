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
          contents: [],
        )) {
    contentRepository.contents.listen((contents) {
      add(OnLoadedContentEvent(
        contents: contents,
      ));
    });

    on<OnLoadedContentEvent>((event, emit) {
      emit(ListContentInitialState(
        contents: event.contents,
      ));
    });
  }
}
