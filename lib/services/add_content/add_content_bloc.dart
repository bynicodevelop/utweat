import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:utweat/respositories/content_repository.dart';

part 'add_content_event.dart';
part 'add_content_state.dart';

class AddContentBloc extends Bloc<AddContentEvent, AddContentState> {
  final ContentRepository contentRepository;

  AddContentBloc({
    required this.contentRepository,
  }) : super(AddContentInitial()) {
    on<OnCreateNewContentEvent>((event, emit) async {
      emit(AddContentLoading());

      try {
        await contentRepository.createNewContent(
          event.content,
        );

        emit(AddContentCreated());
      } catch (e) {
        emit(AddContentFailure(
          e.toString(),
        ));
      }
    });
  }
}
