class UTweatGenerator {
  final String pattern;
  late final Iterable<RegExpMatch> matches;
  final String branding;
  final int maxChars;

  UTweatGenerator(
    this.pattern, {
    this.branding = "@byutweat",
    this.maxChars = 280,
  }) {
    RegExp regExp = RegExp(r"\{([^\{\}]*)\}");

    matches = regExp.allMatches(pattern);
  }

  int _basePossibilites() {
    List<int> nMaches = [];

    for (int i = 0; i < matches.length; i++) {
      final List<String> pin = matches.elementAt(i).group(1)!.split("|");
      nMaches.add(pin.length);
    }

    return nMaches.fold(1, (previous, current) => previous * current);
  }

  String _generateContent() {
    String content = pattern;

    return matches.fold(content, (previousValue, currentValue) {
      List<String> pins = currentValue.group(1)!.split("|");
      pins.shuffle();

      return previousValue.replaceAll("{${currentValue.group(1)}}", pins.first);
    });
  }

  List<String> _generateListContent(int nPossibilites) {
    List<String> list = [];

    while (list.length < nPossibilites) {
      String content = "${_generateContent()} $branding";

      if (!list.contains(content)) {
        list.add(content);
      }
    }

    return list;
  }

  List<String> get listString {
    int numberPossibilites = _basePossibilites();

    List<String> list = _generateListContent(numberPossibilites);

    return list.where((content) => content.length <= maxChars).toList();
  }

  int get possibilities {
    int numberPossibilites = _basePossibilites();

    List<String> list = _generateListContent(numberPossibilites);

    numberPossibilites =
        list.where((content) => content.length <= maxChars).length;

    return numberPossibilites;
  }
}
