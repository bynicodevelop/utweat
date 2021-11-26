import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:utweat/helpers/utweat_generator.dart';
import 'package:utweat/models/content_model.dart';
import 'package:utweat/respositories/content_repository.dart';

part 'generate_content_event.dart';
part 'generate_content_state.dart';

class GenerateContentBloc
    extends Bloc<GenerateContentEvent, GenerateContentState> {
  final ContentRepository contentRepository;

  GenerateContentBloc({
    required this.contentRepository,
  }) : super(GenerateContentInitial()) {
    on<OnGenerateContentEvent>((event, emit) async {
      emit(GenerateContentLoadingState());

      try {
        ContentModel contentModel =
            await contentRepository.getContent(event.uid);
        List<String> contentsUsed =
            await contentRepository.getContentsUsed(event.uid);

        UTweatGenerator utweatGenerator = UTweatGenerator(contentModel.content);

        List<String> contentFound = utweatGenerator.listString
            .where((content) => !contentsUsed.contains(content))
            .toList();

        String content = contentFound.first;

        emit(GenerateContentLoadedState(
          content: content,
        ));

        await contentRepository.updateContentUsed(
          contentModel,
          content,
        );
      } catch (e) {
        emit(GenerateContentFailureState(
          error: e.toString(),
        ));
      }
    });
  }
}
