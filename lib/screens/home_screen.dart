import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utweat/components/content_editor_component.dart';
import 'package:utweat/helpers/translate.dart';
import 'package:utweat/services/add_content/add_content_bloc.dart';
import 'package:utweat/services/delete_content/delete_content_bloc.dart';
import 'package:utweat/services/generate_content/generate_content_bloc.dart';
import 'package:utweat/services/list_content/list_content_bloc.dart';

List<Map<String, dynamic>> contents = [];

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  void _modal(BuildContext context) => showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return BlocListener<AddContentBloc, AddContentState>(
            listener: (context, state) {
              if (state is AddContentCreated) {
                Navigator.pop(context);
              }
            },
            child: const ContentEditorController(),
          );
        },
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UTweat'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _modal(context),
          ),
        ],
      ),
      body: MultiBlocListener(
        listeners: [
          BlocListener<GenerateContentBloc, GenerateContentState>(
            listener: (context, state) async {
              if (state is GenerateContentLoadedState) {
                await Clipboard.setData(
                  ClipboardData(
                    text: state.content,
                  ),
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      t(context)!.contentCopiedToClipboard,
                    ),
                  ),
                );

                context.read<ListContentBloc>().add(OnLoadedContentEvent());
              }
            },
          ),
          BlocListener<DeleteContentBloc, DeleteContentState>(
            listener: (context, state) async {
              if (state is DeleteContentSuccessState) {
                context.read<ListContentBloc>().add(OnLoadedContentEvent());
              }
            },
          ),
        ],
        child: BlocBuilder<ListContentBloc, ListContentState>(
          builder: (context, state) {
            if (state is ListContentInitialState) {
              return state.contents.isEmpty
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              text: t(context)!.helperNoContentPart1,
                              style: Theme.of(context).textTheme.bodyText2,
                              children: [
                                TextSpan(
                                    text: "{hello|bonjour} {world|monde} ",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyText2!
                                        .copyWith(
                                          fontStyle: FontStyle.italic,
                                        )),
                                TextSpan(
                                  text: t(context)!.helperNoContentPart2,
                                )
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            t(context)!.gettingStarted,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(8),
                      itemCount: state.contents.length,
                      itemBuilder: (context, index) {
                        return Dismissible(
                          key: Key(
                            "$index-${DateTime.now().microsecondsSinceEpoch}",
                          ),
                          onDismissed: (direction) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(
                                  SnackBar(
                                    duration: const Duration(
                                      seconds: 3,
                                    ),
                                    content: Text(
                                        t(context)!.deletionContentMessage),
                                    action: SnackBarAction(
                                      label: t(context)!.cancelButton,
                                      onPressed: () {
                                        context
                                            .read<ListContentBloc>()
                                            .add(OnLoadedContentEvent());
                                      },
                                    ),
                                  ),
                                )
                                .closed
                                .then((value) {
                              if (value == SnackBarClosedReason.timeout) {
                                context.read<DeleteContentBloc>().add(
                                      OnDeleteContentEvent(
                                        uid: state.contents[index].uid,
                                      ),
                                    );
                              }
                            });
                          },
                          direction: DismissDirection.endToStart,
                          background: Container(
                            alignment: AlignmentDirectional.centerEnd,
                            color: Colors.red,
                            child: const Padding(
                              padding: EdgeInsets.fromLTRB(0.0, 0.0, 20.0, 0.0),
                              child: Icon(
                                Icons.delete,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          child: Card(
                            child: ListTile(
                              title: Text(
                                state.contents[index].description,
                              ),
                              subtitle: Text(
                                "Tweets : ${state.contents[index].possibilities - state.contents[index].contents.length}",
                              ),
                              trailing: IconButton(
                                onPressed: () async {
                                  context.read<GenerateContentBloc>().add(
                                        OnGenerateContentEvent(
                                          uid: state.contents[index].uid,
                                        ),
                                      );
                                },
                                icon: const Icon(
                                  Icons.share,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}
