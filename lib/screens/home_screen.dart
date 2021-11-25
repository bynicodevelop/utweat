import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utweat/components/content_editor_component.dart';
import 'package:utweat/services/list_content/list_content_bloc.dart';

List<Map<String, dynamic>> contents = [];

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  void _modal(BuildContext context) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return const ContentEditorController();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('UTweat'),
      ),
      body: BlocBuilder<ListContentBloc, ListContentState>(
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
                      return Card(
                        child: ListTile(
                          title: Text(
                            state.contents[index].name,
                          ),
                          subtitle: Text(
                            "Reste : ${state.contents[index].possibilities}",
                          ),
                          trailing: IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Icons.share,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _modal(context),
        child: const Icon(Icons.add),
      ),
    );
  }
}
