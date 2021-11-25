import 'package:utweat/models/content_model.dart';

class ContentRepository {
  Stream<List<ContentModel>> get contents => Stream.value(
        const [
          ContentModel(
            name: "First tweet",
            content: "{coucou|hello} commen {vas-tu|tu vas} ?",
            possibilities: 10,
            tweets: [],
          ),
          ContentModel(
            name: "Second tweet",
            content: "{coucou|hello} commen {vas-tu|tu vas} ?",
            possibilities: 8,
            tweets: [],
          ),
        ],
      );
}
