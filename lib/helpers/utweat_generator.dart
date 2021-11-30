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

    return matches.fold(content, (previousValue, currentValue) {
      List<String> pins = currentValue.group(1)!.split("|");
      pins.shuffle();

      return previousValue.replaceAll("{${currentValue.group(1)}}", pins.first);
    });
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
