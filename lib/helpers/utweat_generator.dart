class UTweatGenerator {
  final String pattern;
  late final Iterable<RegExpMatch> matches;

  UTweatGenerator(
    this.pattern,
  ) {
    RegExp regExp = RegExp(r"\{([^\{\}]*)\}*");

    matches = regExp.allMatches(pattern);
  }

  Iterable<RegExpMatch> _findPattern(String content) {
    RegExp regExp = RegExp(r"\{([^\{\}]*)\}*");

    return regExp.allMatches(content);
  }

  String _generate() {
    String content = pattern;

    Iterable<RegExpMatch> localMatched =
        _findPattern(content).toList().reversed;

    while (localMatched.isNotEmpty) {
      final List<String> pin = localMatched.elementAt(0).group(1)!.split("|");

      pin.shuffle();

      content = content.replaceAll(
        "{${localMatched.elementAt(0).group(1)}}",
        pin.first,
      );

      localMatched = _findPattern(content).toList().reversed;
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
