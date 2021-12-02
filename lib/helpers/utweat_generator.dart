import 'dart:developer' as developer;

import 'package:math_expressions/math_expressions.dart';

class UTweatGenerator {
  final String pattern;
  final String regex;

  const UTweatGenerator(
    this.pattern,
    this.regex,
  );

  List<String> matches({
    String? pattern,
  }) {
    pattern ??= this.pattern;

    RegExp regExp = RegExp(regex);

    Iterable<RegExpMatch> matches = regExp.allMatches(pattern);

    return matches.map((match) => match.group(0)!).toList();
  }

  List<String> extractPin(String pin) {
    RegExp regExp = RegExp(r"\{([^\{\}]*)\}");

    Iterable<RegExpMatch> matches = regExp.allMatches(pin);

    return matches.map((match) => match.group(1)!).first.split("|");
  }

  Map<String, dynamic> extractPins(List<String> pins) {
    Map<String, dynamic> result = {};

    for (String pin in pins) {
      result[pin] = extractPin(pin);
    }

    return result;
  }

  List<Map<String, int>> convertSpinToPossibilites(List<String> spins) =>
      spins.map((spin) {
        Map<String, int> result = {};

        result[spin] = spin.split("|").length;

        return result;
      }).toList();

  int possibilites({
    String? pattern,
  }) {
    pattern ??= this.pattern;

    String expression = pattern.split('').where((char) {
      if (char == '{' || char == '}' || char == '|') {
        return true;
      }

      return false;
    }).map((char) {
      if (char == '{') {
        return '(1';
      }

      if (char == '}') {
        return ')';
      }

      if (char == '|') {
        return '+1';
      }

      return char;
    }).join();

    if (expression.isEmpty) {
      return 1;
    }

    expression = expression
        .split(")(")
        .join(")*(")
        .split("+1(")
        .join("+(")
        .split("1(")
        .join("1+(");

    Parser p = Parser();
    Expression exp = p.parse(expression);

    Variable x = Variable('x');

    ContextModel cm = ContextModel();
    cm.bindVariable(x, exp);

    int eval = (exp.evaluate(EvaluationType.REAL, cm)).toInt();

    return eval;
  }

  List<String> listPossibilitesFromPipe(String value) => value.split("|");

  String generateContent({
    String? pattern,
  }) {
    pattern ??= this.pattern;

    List<String> listMatch = matches(
      pattern: pattern,
    );

    Map<String, dynamic> mapPins = extractPins(listMatch);

    return mapPins.entries.fold<String>(
      pattern,
      (previousValue, element) {
        (element.value as List<String>).shuffle();

        return previousValue.replaceAll(
          element.key,
          element.value.first,
        );
      },
    );
  }

  String _generate(String content) {
    content = generateContent(
      pattern: pattern,
    );

    List<String> listMatch = matches(
      pattern: content,
    );

    if (listMatch.isNotEmpty) {
      content = generateContent(
        pattern: content,
      );
    }

    return content;
  }

  List<String> generate({
    int limit = 100,
  }) {
    int i = 0;
    int n = possibilites();

    bool limitNotExceeded = true;

    List<String> list = [];

    while (list.length < n && limitNotExceeded) {
      String content = _generate(pattern);

      if (!list.contains(content)) {
        list.add(content);
      }

      i++;

      if (i == limit) {
        developer.log("Limit exceeded");
        limitNotExceeded = false;
      }
    }

    return list;
  }
}
