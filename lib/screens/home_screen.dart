import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:utweat/components/content_editor_component.dart';
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
      ),
      body: BlocListener<GenerateContentBloc, GenerateContentState>(
        listener: (context, state) async {
          if (state is GenerateContentLoadedState) {
            // print(state.content);
            Map<String, dynamic> query = {
              "text": state.content,
            };

            await launch(Uri(
                    scheme: "https",
                    host: "twitter.com",
                    path: "intent/tweet",
                    queryParameters: query)
                .toString());

            context.read<ListContentBloc>().add(OnLoadedContentEvent());
          }
        },
        child: BlocBuilder<ListContentBloc, ListContentState>(
          builder: (context, state) {
            if (state is ListContentInitialState) {
              return state.contents.isEmpty
                  ? const Center(
                      child: Text("No content"),
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
                                    content:
                                        const Text("Your content was deleted"),
                                    action: SnackBarAction(
                                      label: "Cancel",
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
                                "Reste : ${state.contents[index].possibilities - state.contents[index].contents.length}",
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _modal(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
