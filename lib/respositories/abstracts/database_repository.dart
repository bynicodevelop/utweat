import 'package:utweat/models/content_model.dart';

abstract class DatabaseRepository {
  Future<void> intializeDatabase(String dbName);

  Future<List<Map<String, dynamic>>> all(String tableName);

  Future<List<Map<String, dynamic>>> allByJoinId(
    String tableName,
    String joinId,
  );

  Future<void> insert(
    ContentModel contentModel,
  );

  Future<void> deleteById(String tableName, String uid);

  Future<Map<String, dynamic>> getById(String uid);

  Future<void> addNewContentsUsed(Map<String, dynamic> content);
}
