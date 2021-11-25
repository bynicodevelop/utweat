class UTweatGenerator {
  final String pattern;
  late final Iterable<RegExpMatch> matches;

  UTweatGenerator(
    this.pattern,
  ) {
    RegExp regExp = RegExp(r"\{([^\{\}]*)\}");

    matches = regExp.allMatches(pattern);
  }

  String _generate() {
    String content = pattern;

    List<int> nMaches = [];

    for (int i = 0; i < matches.length; i++) {
      final List<String> pin = matches.elementAt(i).group(1)!.split("|");
      nMaches.add(pin.length);

      pin.shuffle();

      content = content.replaceAll(
        "{${matches.elementAt(i).group(1)}}",
        pin.first,
      );
    }

    return content;
  }

  List<String> get listString {
    List<String> list = [];

    while (list.length < possibilities) {
      String content = _generate();

      if (!list.contains(content)) {
        list.add(content);
      }
    }

    return list;
  }

  int get possibilities {
    List<int> nMaches = [];

    for (int i = 0; i < matches.length; i++) {
      final List<String> pin = matches.elementAt(i).group(1)!.split("|");
      nMaches.add(pin.length);
    }

    return nMaches.fold(1, (previous, current) => previous * current);
  }
}
