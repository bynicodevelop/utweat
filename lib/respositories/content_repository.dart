import 'dart:async';

import 'package:utweat/models/content_model.dart';
import 'package:utweat/respositories/abstracts/database_repository.dart';

class ContentRepository {
  final DatabaseRepository databaseRepository;

  ContentRepository(this.databaseRepository);

  final StreamController<List<ContentModel>> _contentController =
      StreamController.broadcast();

  final List<ContentModel> _contentList = [];

  Stream<List<ContentModel>> get contents => _contentController.stream;

  Future<void> load() async {
    List<Map<String, dynamic>> contents =
        await databaseRepository.all("contents");

    List<ContentModel> contentModel =
        await Future.wait(contents.map((content) async {
      List<Map<String, dynamic>> contentsUsed =
          await databaseRepository.allByJoinId(
        "contents_used",
        content["uid"].toString(),
      );

      return ContentModel.fromJson({
        ...content,
        ...{
          "contents": contentsUsed.map<String>((e) => e["content"]).toList(),
        }
      });
    }).toList());

    _contentList.addAll(contentModel);
    _contentController.add(contentModel);
  }

  Future<void> createNewContent(Map<String, dynamic> data) async {
    ContentModel contentModel = ContentModel.fromJson({
      ...data,
      ...{
        "uid": _contentList.length + 1,
        "contents": List<String>.from([]),
        "account_uid": 1,
      },
    });

    databaseRepository.insert(contentModel);

    _contentList.add(contentModel);

    _contentController.add(_contentList);
  }

  Future<void> deleteContent(String uid) async {
    List<Map<String, dynamic>> contentsUsed =
        await databaseRepository.allByJoinId("contents_used", uid);

    for (var contentUsed in contentsUsed) {
      await databaseRepository.deleteById(
        "contents_used",
        contentUsed["uid"].toString(),
      );
    }

    await databaseRepository.deleteById("contents", uid);

    _contentList.removeWhere(
      (ContentModel contentModel) => contentModel.uid == uid,
    );

    _contentController.add(_contentList);
  }

  Future<ContentModel> getContent(String uid) async {
    Map<String, dynamic> map = await databaseRepository.getById(uid);

    List<Map<String, dynamic>> contentsUsed =
        await databaseRepository.allByJoinId(
      "contents_used",
      uid,
    );

    if (map["uid"] == null) throw Exception("Content not found");

    return ContentModel.fromJson({
      ...map,
      ...{
        "contents": contentsUsed.map<String>((e) => e["content"]).toList(),
      },
    });
  }

  Future<List<String>> getContentsUsed(String uid) async {
    List<Map<String, dynamic>> contentsUsedList =
        await databaseRepository.allByJoinId("contents_used", uid);

    return contentsUsedList.isEmpty
        ? List<String>.from([])
        : contentsUsedList.map<String>((e) => e["content"]).toList();
  }

  Future<void> updateContentUsed(
    ContentModel contentModel,
    String content,
  ) async {
    List<Map<String, dynamic>> contentsUsedList =
        await databaseRepository.all("contents_used");

    await databaseRepository.addNewContentsUsed({
      "uid": contentsUsedList.length + 1,
      "content": content,
      "content_uid": contentModel.uid,
    });
  }
}
