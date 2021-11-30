import 'package:flutter_test/flutter_test.dart';
import 'package:utweat/helpers/utweat_generator.dart';

void main() {
  group("UTweatGenerator.possibilities", () {
    test("Should return 2 possibilities", () {
      // ARRANGE
      final UTweatGenerator utweatGenerator = UTweatGenerator("{test|test2}");

      // ACT
      int value = utweatGenerator.possibilities;

      // ASSERT
      expect(value, 2);
    });

    test("Should return 1 possibilities", () {
      // ARRANGE
      final UTweatGenerator utweatGenerator = UTweatGenerator("test2");

      // ACT
      int value = utweatGenerator.possibilities;

      // ASSERT
      expect(value, 1);
    });

    test("Should return 4 possibilities", () {
      // ARRANGE
      final UTweatGenerator utweatGenerator =
          UTweatGenerator("{test|test2}{toto|tata}");

      // ACT
      int value = utweatGenerator.possibilities;

      // ASSERT
      expect(value, 4);
    });

    // test("Should return 8 possibilities", () {
    //   // ARRANGE
    //   final UTweatGenerator utweatGenerator =
    //       UTweatGenerator("{test|test2 {re1|re2}}{toto|tata}");

    //   // ACT
    //   int value = utweatGenerator.possibilities;

    //   // ASSERT
    //   expect(value, 8);
    // });
  });

  group("UTweatGenerator.listString", () {
    test("Should return 2 results", () {
      // ARRANGE
      final UTweatGenerator utweatGenerator = UTweatGenerator("{test|test2}");

      // ACT
      int value = utweatGenerator.listString.length;

      // ASSERT
      expect(value, 2);
    });

    test("Should return 4 results", () {
      // ARRANGE
      final UTweatGenerator utweatGenerator =
          UTweatGenerator("{hello|coucou} {john|jane}");

      // ACT
      List<String> values = utweatGenerator.listString;

      // ASSERT
      expect(values.length, 4);

      for (var value in [
        "hello john @byutweat",
        "hello jane @byutweat",
        "coucou jane @byutweat",
        "coucou john @byutweat",
      ]) {
        expect(values.contains(value), true);
      }
    });

    // test("Should return 3 results (2)", () {
    //   // ARRANGE
    //   final UTweatGenerator utweatGenerator =
    //       UTweatGenerator("{hello|coucou {john|jane}}");

    //   // ACT
    //   List<String> values = utweatGenerator.listString;

    //   // ASSERT
    //   expect(values.length, 3);

    //   for (var value in [
    //     "hello jane",
    //     "coucou jane",
    //     "coucou john",
    //   ]) {
    //     expect(values.contains(value), true);
    //   }
    // });

    // test("Should return 4 results (2)", () {
    //   // ARRANGE
    //   final UTweatGenerator utweatGenerator =
    //       UTweatGenerator("{hello|coucou {john|jane|{qsd|sqdff}}}");

    //   // ACT
    //   List<String> values = utweatGenerator.listString;

    //   // ASSERT
    //   expect(values.length, 4);

    //   for (var value in [
    //     "hello jane",
    //     "coucou jane",
    //     "coucou john",
    //   ]) {
    //     expect(values.contains(value), true);
    //   }
    // });
  });
}
