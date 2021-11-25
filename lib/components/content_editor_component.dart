import 'package:flutter/material.dart';
import 'package:utweat/helpers/utweat_generator.dart';

class ContentEditorController extends StatefulWidget {
  const ContentEditorController({Key? key}) : super(key: key);

  @override
  _ContentEditorControllerState createState() =>
      _ContentEditorControllerState();
}

class _ContentEditorControllerState extends State<ContentEditorController> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  final FocusNode _contentFocusNode = FocusNode();

  int _int = 0;

  @override
  void initState() {
    super.initState();

    _contentController.addListener(() {
      UTweatGenerator uTweatGenerator =
          UTweatGenerator(_contentController.text);

      setState(() => _int = uTweatGenerator.possibilities);
    });
  }

  @override
  void dispose() {
    _contentController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 10.0,
        right: 10.0,
        top: 10.0,
      ),
      child: Wrap(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              bottom: 15.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Tweet editor",
                  style: Theme.of(context).textTheme.headline6,
                ),
                Row(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        int start = 0;
                        int end = 0;

                        final TextSelection selection =
                            _contentController.selection;

                        if (!_contentFocusNode.hasFocus) {
                          _contentFocusNode.requestFocus();
                        } else {
                          start = selection.start;
                          end = selection.end;
                        }

                        if (start == end) {
                          _contentController.text =
                              _contentController.text.replaceRange(
                            start,
                            end,
                            "{|}",
                          );

                          _contentController.selection =
                              TextSelection.collapsed(
                            offset: end + 1,
                          );
                        } else {
                          String selectedText =
                              selection.textInside(_contentController.text);

                          _contentController.text =
                              _contentController.text.replaceRange(
                            start,
                            end,
                            "{$selectedText|}",
                          );

                          _contentController.selection =
                              TextSelection.collapsed(
                            offset: end + 1,
                          );
                        }
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(30, 30),
                      ),
                      child: const Text("{ }"),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        int start = 0;
                        int end = 0;

                        final TextSelection selection =
                            _contentController.selection;

                        if (!_contentFocusNode.hasFocus) {
                          _contentFocusNode.requestFocus();
                        } else {
                          start = selection.start;
                          end = selection.end;
                        }

                        _contentController.text =
                            _contentController.text.replaceRange(
                          start,
                          start,
                          "|",
                        );

                        _contentController.selection = TextSelection.collapsed(
                          offset: end + 1,
                        );
                      },
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(30, 30),
                      ),
                      child: const Text("|"),
                    )
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 20.0,
            ),
            child: TextField(
              autofocus: true,
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Enter the name of pattern',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          TextField(
            controller: _contentController,
            focusNode: _contentFocusNode,
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
              labelText: 'Enter your Tweet',
              border: const OutlineInputBorder(),
              helperText: "Possibilites : $_int",
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
              bottom: 10.0,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Cancel"),
                ),
                TextButton(
                  onPressed: () {
                    UTweatGenerator uTweatGenerator =
                        UTweatGenerator(_contentController.text);

                    print(uTweatGenerator.listString);
                  },
                  child: const Text("Create"),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
