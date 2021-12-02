import 'package:flutter_test/flutter_test.dart';
import 'package:utweat/helpers/utweat_generator.dart';

main() {
  group("_matches", () {
    test("Should return an empty list of matches with empty String", () {
      // ARRANGE
      const UTweatGenerator generator = UTweatGenerator(
        "",
        r"(\{[^\{\}]*\})",
      );

      // ACT
      List<String> result = generator.matches();

      // ASSERT
      expect(result.length, 0);
    });

    test("Should return an empty list of matches with standard String", () {
      // ARRANGE
      const UTweatGenerator generator = UTweatGenerator(
        "coucou",
        r"(\{[^\{\}]*\})",
      );

      // ACT
      List<String> result = generator.matches();

      // ASSERT
      expect(result.length, 0);
    });

    test("Should return a list of matches", () {
      // ARRANGE
      const UTweatGenerator generator = UTweatGenerator(
        "{coucou|hello}",
        r"(\{[^\{\}]*\})",
      );

      // ACT
      List<String> result = generator.matches();

      // ASSERT
      expect(result, ["{coucou|hello}"]);

      expect(result.length, 1);
    });

    test("Should return a list of matches ({coucou | qsd {re|qsd}})", () {
      // ARRANGE
      const UTweatGenerator generator = UTweatGenerator(
        "{coucou | qsd {re|qsd}}",
        r"(\{[^\{\}]*\})",
      );

      // ACT
      List<String> result = generator.matches();

      // ASSERT
      expect(result, [
        "{re|qsd}",
      ]);

      expect(result.length, 1);
    });

    test(
        "Should return a list of matches ({coucou | qsd {re|qsd}} {recoucou | reqsd {rere|qresd}})",
        () {
      // ARRANGE
      const UTweatGenerator generator = UTweatGenerator(
        "{coucou | qsd {re|qsd}} {recoucou | reqsd {rere|qresd}}",
        r"(\{[^\{\}]*\})",
      );

      // ACT
      List<String> result = generator.matches();

      // ASSERT
      expect(result, [
        "{re|qsd}",
        "{rere|qresd}",
      ]);

      expect(result.length, 2);
    });

    test("Should return a list of matches with complexe String", () {
      // ARRANGE
      const UTweatGenerator generator = UTweatGenerator(
        "{hello|coucou} {world|le monde} comment vas-{tu|t'y} {bibi| no {qqq|Mmm}}",
        r"(\{[^\{\}]*\})",
      );

      // ACT
      List<String> result = generator.matches();

      // ASSERT
      expect(result, [
        "{hello|coucou}",
        "{world|le monde}",
        "{tu|t'y}",
        "{qqq|Mmm}",
      ]);

      expect(result.length, 4);
    });
  });

  group("extractPins", () {
    test("Should return a list of pin form string ({hello|coucou})", () {
      // ARRANGE
      const UTweatGenerator generator = UTweatGenerator(
        "{hello|coucou}",
        r"(\{[^\{\}]*\})",
      );

      // ACT
      List<String> result = generator.extractPin("{hello|coucou}");

      // ASSERT
      expect(result, [
        "hello",
        "coucou",
      ]);

      expect(result.length, 2);
    });

    test("Should return a list of pin form string ({hello|coucou|toto})", () {
      // ARRANGE
      const UTweatGenerator generator = UTweatGenerator(
        "{hello|coucou|toto}",
        r"(\{[^\{\}]*\})",
      );

      // ACT
      List<String> result = generator.extractPin("{hello|coucou|toto}");

      // ASSERT
      expect(result, [
        "hello",
        "coucou",
        "toto",
      ]);

      expect(result.length, 3);
    });
  });

  group("extractPins", () {
    test("Should return a list of pin form string ({hello|coucou} {bibi|bobo})",
        () {
      // ARRANGE
      const UTweatGenerator generator = UTweatGenerator(
        "",
        r"(\{[^\{\}]*\})",
      );

      // ACT
      Map<String, dynamic> result =
          generator.extractPins(["{hello|coucou}", "{bibi|bobo}"]);

      // ASSERT
      expect(result, {
        "{hello|coucou}": ["hello", "coucou"],
        "{bibi|bobo}": ["bibi", "bobo"],
      });
    });

    test(
        "Should return a list of pin form string ({hello|coucou} {bibi|bobo} {test 1|test 2|test 3})",
        () {
      // ARRANGE
      const UTweatGenerator generator = UTweatGenerator(
        "",
        r"(\{[^\{\}]*\})",
      );

      // ACT
      Map<String, dynamic> result = generator.extractPins(
          ["{hello|coucou}", "{bibi|bobo}", "{test 1|test 2|test 3}"]);

      // ASSERT
      expect(result, {
        "{hello|coucou}": ["hello", "coucou"],
        "{bibi|bobo}": ["bibi", "bobo"],
        "{test 1|test 2|test 3}": ["test 1", "test 2", "test 3"],
      });
    });

    test("Should return a list of pin form string ({hello|coucou|toto})", () {
      // ARRANGE
      const UTweatGenerator generator = UTweatGenerator(
        "{hello|coucou|toto}",
        r"(\{[^\{\}]*\})",
      );

      // ACT
      List<String> result = generator.extractPin("{hello|coucou|toto}");

      // ASSERT
      expect(result, [
        "hello",
        "coucou",
        "toto",
      ]);

      expect(result.length, 3);
    });
  });

  group("listPossibilitesFromPipe", () {
    test("Should return 1 result (2)", () {
      // ARRANGE
      const UTweatGenerator generator = UTweatGenerator("", "");

      // ACT
      List<Map<String, int>> result = generator.convertSpinToPossibilites([
        "{hello|coucou}",
      ]);

      // ASSERT
      expect(result.length, 1);
      expect(result.first["{hello|coucou}"], 2);
    });

    test("Should return 2 result (2, 3)", () {
      // ARRANGE
      const UTweatGenerator generator = UTweatGenerator("", "");

      // ACT
      List<Map<String, int>> result = generator.convertSpinToPossibilites([
        "{hello|coucou}",
        "{hello|coucou|super}",
      ]);

      // ASSERT
      expect(result.length, 2);
      expect(result.first["{hello|coucou}"], 2);
      expect(result.last["{hello|coucou|super}"], 3);
    });
  });

  group("possibilites", () {
    test("Should replace pattern with mocks (hello)", () {
      // ARRANGE
      const UTweatGenerator generator = UTweatGenerator(
        "hello",
        r"(\{[^\{\}]*\})",
      );

      // ACT
      int result = generator.possibilites(
        pattern: "hello",
      );

      // ASSERT
      expect(result, 1);
    });

    test("Should replace pattern with mocks ({hello|coucou})", () {
      // ARRANGE
      const UTweatGenerator generator = UTweatGenerator(
        "{hello|coucou}",
        r"(\{[^\{\}]*\})",
      );

      // ACT
      int result = generator.possibilites(
        pattern: "{hello|coucou}",
      );

      // ASSERT
      expect(result, 2);
    });

    test("Should replace pattern with mocks ({hello|coucou} {toto|titi})", () {
      // ARRANGE
      const UTweatGenerator generator = UTweatGenerator(
        "{hello|coucou} {toto|titi}",
        r"(\{[^\{\}]*\})",
      );

      // ACT
      int result = generator.possibilites(
        pattern: "{hello|coucou} {toto|titi}",
      );

      // ASSERT
      expect(result, 4);
    });

    test("Should replace pattern with mocks ({toto|titi {s|d}})", () {
      // ARRANGE
      const UTweatGenerator generator = UTweatGenerator(
        "{toto|titi {s|d}}",
        r"(\{[^\{\}]*\})",
      );

      // ACT
      int result = generator.possibilites(
        pattern: "{toto|titi {s|d}}",
      );

      // ASSERT
      expect(result, 3);
    });

    test("Should replace pattern with mocks ({hello|coucou} le monde)", () {
      // ARRANGE
      const UTweatGenerator generator = UTweatGenerator(
        "{hello|coucou} le monde",
        r"(\{[^\{\}]*\})",
      );

      // ACT
      int result = generator.possibilites(
        pattern: "{hello|coucou} le monde",
      );

      // ASSERT
      expect(result, 2);
    });

    test(
        "Should replace pattern with mocks ({hello|coucou} {bibi| bobo {ca va|ca va}})",
        () {
      // ARRANGE
      const UTweatGenerator generator = UTweatGenerator(
        "{hello|coucou} {bibi| bobo {ca va|ca va}}",
        r"(\{[^\{\}]*\})",
      );

      // ACT
      int result = generator.possibilites(
          pattern: "{hello|coucou} {bibi| bobo {ca va|ca va}}");

      // ASSERT
      expect(result, 6);
    });

    test("Should replace pattern with mocks (coucou {ca {va|roule}})", () {
      // ARRANGE
      const UTweatGenerator generator = UTweatGenerator(
        "coucou {ca {va|roule}}",
        r"(\{[^\{\}]*\})",
      );

      // ACT
      int result = generator.possibilites(pattern: "coucou {ca {va|roule}}");

      // ASSERT
      expect(result, 3);
    });

    test("Should replace pattern with mocks ({re|test} coucou {ca {va|roule}})",
        () {
      // ARRANGE
      const UTweatGenerator generator = UTweatGenerator(
        "{re|test} coucou {ca {va|roule}}",
        r"(\{[^\{\}]*\})",
      );

      // ACT
      int result =
          generator.possibilites(pattern: "{re|test} coucou {ca {va|roule}}");

      // ASSERT
      expect(result, 6);
    });

    test(
        "Should replace pattern with mocks ({re|test} coucou {ca {va|roule}} sqdqs)",
        () {
      // ARRANGE
      const UTweatGenerator generator = UTweatGenerator(
        "{re|test} coucou {ca {va|roule}} sqdqs",
        r"(\{[^\{\}]*\})",
      );

      // ACT
      int result = generator.possibilites(
          pattern: "{re|test} coucou {ca {va|roule}} sqdqs");

      // ASSERT
      expect(result, 6);
    });
  });

  group("generateContent", () {
    test("Should generate simple string ({hello|coucou})", () {
      // ARRANGE
      bool found = false;

      const UTweatGenerator generator = UTweatGenerator(
        "{hello|coucou}",
        r"(\{[^\{\}]*\})",
      );

      // ACT
      String content = generator.generateContent();

      // ASSERT
      for (String value in ["hello", "coucou"]) {
        if (value == content) {
          found = true;
        }
      }

      expect(found, true);
    });

    test("Should generate simple string ({hello|coucou} {bobo|bibi})", () {
      // ARRANGE
      bool found = false;

      const UTweatGenerator generator = UTweatGenerator(
        "{hello|coucou} {bobo|bibi}",
        r"(\{[^\{\}]*\})",
      );

      // ACT
      String content = generator.generateContent();

      // ASSERT
      for (String value in [
        "hello bobo",
        "hello bibi",
        "coucou bobo",
        "coucou bibi"
      ]) {
        if (value == content) {
          found = true;
        }
      }

      expect(found, true);
    });

    test("Should generate simple string ({hello|coucou {john|jane}})", () {
      // ARRANGE
      bool found = false;

      const UTweatGenerator generator = UTweatGenerator(
        "{hello|coucou {john|jane}}",
        r"(\{[^\{\}]*\})",
      );

      // ACT
      String content = generator.generateContent();

      content = generator.generateContent(
        pattern: content,
      );

      // ASSERT
      for (String value in [
        "hello",
        "coucou john",
        "coucou jane",
      ]) {
        if (value == content) {
          found = true;
        }
      }

      expect(found, true);
    });

    test("Should generate simple string ({hello|coucou {john|jane {re|to}}})",
        () {
      // ARRANGE
      bool found = false;

      const UTweatGenerator generator = UTweatGenerator(
        "{hello|coucou {john|jane {re|to}}}",
        r"(\{[^\{\}]*\})",
      );

      // ACT
      String content = generator.generateContent();

      content = generator.generateContent(
        pattern: content,
      );

      content = generator.generateContent(
        pattern: content,
      );

      // ASSERT
      for (String value in [
        "hello",
        "coucou john",
        "coucou jane re",
        "coucou jane to",
      ]) {
        if (value == content) {
          found = true;
        }
      }

      expect(found, true);
    });

    test(
        "Should generate simple string ({1|2} {hello|coucou {john|jane {re|to}}})",
        () {
      // ARRANGE
      bool found = false;

      const UTweatGenerator generator = UTweatGenerator(
        "{1|2} {hello|coucou {john|jane {re|to}}}",
        r"(\{[^\{\}]*\})",
      );

      // ACT
      String content = generator.generateContent();

      content = generator.generateContent(
        pattern: content,
      );

      content = generator.generateContent(
        pattern: content,
      );

      // ASSERT
      for (String value in [
        "1 hello",
        "2 hello",
        "1 coucou john",
        "2 coucou john",
        "2 coucou jane re",
        "2 coucou jane to",
      ]) {
        if (value == content) {
          found = true;
        }
      }

      expect(found, true);
    });
  });

  group("listPossibilitesFromPipe(String)", () {
    test("Should return 1 result", () {
      // ARRANGE
      const UTweatGenerator utweatGenerator = UTweatGenerator(
        "coucou",
        r"(\{[^\{\}]*\})",
      );

      // ACT
      List<String> result = utweatGenerator.listPossibilitesFromPipe("coucou");

      // ASSERT
      for (var value in result) {
        expect(value, anyOf(["coucou"]));
      }

      expect(result.length, 1);
    });

    test("Should return 2 results", () {
      // ARRANGE
      const UTweatGenerator utweatGenerator = UTweatGenerator(
        "{coucou|hello}",
        r"(\{[^\{\}]*\})",
      );

      // ACT
      List<String> result =
          utweatGenerator.listPossibilitesFromPipe("coucou|hello");

      // ASSERT
      for (var value in result) {
        expect(value, anyOf(["coucou", "hello"]));
      }

      expect(result.length, 2);
    });

    test("Should return 3 results", () {
      // ARRANGE
      const UTweatGenerator utweatGenerator = UTweatGenerator(
        "{coucou|hello|yo}",
        r"(\{[^\{\}]*\})",
      );

      // ACT
      List<String> result =
          utweatGenerator.listPossibilitesFromPipe("coucou|hello|yo");

      // ASSERT
      for (var value in result) {
        expect(value, anyOf(["coucou", "hello", "yo"]));
      }

      expect(result.length, 3);
    });
  });

  group("generate", () {
    test("Should return a list of string with {coucou|hello}", () {
      // ARRANGE
      const UTweatGenerator utweatGenerator = UTweatGenerator(
        "{coucou|hello}",
        r"(\{[^\{\}]*\})",
      );

      // ACT
      List<String> result = utweatGenerator.generate();

      // ASSERT
      bool found = true;

      for (var element in [
        "coucou",
        "hello",
      ]) {
        found = result.contains(element);
      }

      expect(result.length, 2);
      expect(found, true);
    });

    test("Should return a list of string with {coucou|hello|yo}", () {
      // ARRANGE
      const UTweatGenerator utweatGenerator = UTweatGenerator(
        "{coucou|hello|yo}",
        r"(\{[^\{\}]*\})",
      );

      // ACT
      List<String> result = utweatGenerator.generate();

      // ASSERT
      bool found = true;

      for (var element in [
        "coucou",
        "hello",
        "yo",
      ]) {
        found = result.contains(element);
      }

      expect(result.length, 3);
      expect(found, true);
    });

    test("Should return a list of string with {coucou|hello} {bobo|bibi}", () {
      // ARRANGE
      const UTweatGenerator utweatGenerator = UTweatGenerator(
        "{coucou|hello} {bobo|bibi}",
        r"(\{[^\{\}]*\})",
      );

      // ACT
      List<String> result = utweatGenerator.generate();

      // ASSERT
      bool found = true;

      for (var element in [
        "coucou bobo",
        "coucou bibi",
        "hello bobo",
        "hello bibi",
      ]) {
        found = result.contains(element);
      }

      expect(result.length, 4);
      expect(found, true);
    });

    test("Should return a list of string with {coucou|hello {bobo|bibi}}", () {
      // ARRANGE
      const UTweatGenerator utweatGenerator = UTweatGenerator(
        "{coucou|hello {bobo|bibi}}",
        r"(\{[^\{\}]*\})",
      );

      // ACT
      List<String> result = utweatGenerator.generate();

      // ASSERT
      bool found = true;

      for (var element in [
        "coucou",
        "hello bobo",
        "hello bibi",
      ]) {
        found = result.contains(element);
      }

      expect(result.length, 3);
      expect(found, true);
    });

    test("Should test limit params (1)", () {
      // ARRANGE
      const UTweatGenerator utweatGenerator = UTweatGenerator(
        "{coucou|hello {bobo|bibi}}",
        r"(\{[^\{\}]*\})",
      );

      // ACT
      List<String> result = utweatGenerator.generate(
        limit: 1,
      );

      // ASSERT
      expect(result.length, 1);
    });

    test("Should test limit params (2)", () {
      // ARRANGE
      const UTweatGenerator utweatGenerator = UTweatGenerator(
        "{coucou|hello {bobo|bibi}}",
        r"(\{[^\{\}]*\})",
      );

      // ACT
      List<String> result = utweatGenerator.generate(
        limit: 2,
      );

      // ASSERT
      expect(result.length, 2);
    });

    // test("Should generate 2 result with this {qsd|qsd}", () {
    //   // ARRANGE
    //   const UTweatGenerator utweatGenerator = UTweatGenerator(
    //     "{qsd|qsd}",
    //     r"(\{[^\{\}]*\})",
    //   );

    //   // ACT
    //   List<String> result = utweatGenerator.generate(
    //     limit: 4,
    //   );

    //   // ASSERT
    //   expect(result.length, 2);
    // });
  });
}
