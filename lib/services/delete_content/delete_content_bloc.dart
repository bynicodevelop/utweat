import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:utweat/respositories/content_repository.dart';

part 'delete_content_event.dart';
part 'delete_content_state.dart';

class DeleteContentBloc extends Bloc<DeleteContentEvent, DeleteContentState> {
  final ContentRepository contentRepository;

  DeleteContentBloc({
    required this.contentRepository,
  }) : super(DeleteContentInitial()) {
    on<OnDeleteContentEvent>((event, emit) async {
      emit(DeleteContentLoadingState());

      try {
        await contentRepository.deleteContent(
          event.uid,
        );

        emit(DeleteContentSuccessState());
      } catch (e) {
        emit(DeleteContentFailureState(e.toString()));
      }
    });
  }
}
