import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:utweat/helpers/utweat_generator.dart';
import 'package:utweat/services/add_content/add_content_bloc.dart';

class ContentEditorController extends StatefulWidget {
  const ContentEditorController({Key? key}) : super(key: key);

  @override
  _ContentEditorControllerState createState() =>
      _ContentEditorControllerState();
}

class _ContentEditorControllerState extends State<ContentEditorController> {
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  final FocusNode _contentFocusNode = FocusNode();

  int _int = 0;
  late TextSelection _selection;

  @override
  void initState() {
    super.initState();

    _contentController.addListener(() {
      if (_contentController.selection.start > -1) {
        setState(() => _selection = _contentController.selection);
      }

      if (_contentController.text.isEmpty) return;

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
                    Padding(
                      padding: const EdgeInsets.only(
                        right: 10.0,
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          int start = 0;
                          int end = 0;

                          if (!_contentFocusNode.hasFocus &&
                              (Platform.isIOS || Platform.isAndroid)) {
                            _contentFocusNode.requestFocus();
                          } else {
                            start = _selection.start;
                            end = _selection.end;
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
                                _selection.textInside(_contentController.text);

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
                          minimumSize: const Size(
                            40,
                            35,
                          ),
                        ),
                        child: Text(
                          "{ }",
                          style: Theme.of(context).textTheme.overline!.copyWith(
                                color: Colors.white,
                              ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        int start = 0;
                        int end = 0;

                        if (!_contentFocusNode.hasFocus &&
                            (Platform.isIOS || Platform.isAndroid)) {
                          _contentFocusNode.requestFocus();
                        } else {
                          start = _selection.start;
                          end = _selection.end;
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
                        minimumSize: const Size(
                          40,
                          35,
                        ),
                      ),
                      child: Text(
                        "|",
                        style: Theme.of(context).textTheme.overline!.copyWith(
                              color: Colors.white,
                            ),
                      ),
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
              keyboardType: TextInputType.text,
              // textInputAction: TextInputAction.next,
              autofocus: true,
              controller: _descriptionController,
              decoration: const InputDecoration(
                labelText: 'Enter the description of pattern',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          TextField(
            controller: _contentController,
            focusNode: _contentFocusNode,
            keyboardType: TextInputType.multiline,
            // textInputAction: TextInputAction.done,
            maxLines: null,
            decoration: InputDecoration(
              labelText: 'Enter your content',
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
                  onPressed: _contentController.text.isEmpty ||
                          _descriptionController.text.isEmpty
                      ? null
                      : () {
                          UTweatGenerator uTweatGenerator =
                              UTweatGenerator(_contentController.text);

                          context.read<AddContentBloc>().add(
                                OnCreateNewContentEvent({
                                  "description": _descriptionController.text,
                                  "content": _contentController.text,
                                  "possibilities":
                                      uTweatGenerator.possibilities,
                                }),
                              );
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
