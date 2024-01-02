import 'package:test/test.dart';
import 'package:jack_syntax_analyzer_dart/check_path.dart';

void main() {
  group('Dir Input', () {
    test('no jack file', () {
      expect(
        () => checkPath('test/inputs/NoJack'),
        throwsException,
      );
      expect(
        () => checkPath('test/inputs/NoJack'),
        throwsA(
          predicate((e) =>
              e is Exception && e.toString().contains('No jack files found')),
        ),
      );
    });

    test('invalid file name', () {
      expect(() => checkPath('test/inputs/InvalidFileName'), throwsException);
      expect(
        () => checkPath('test/inputs/InvalidFileName'),
        throwsA(
          predicate((e) =>
              e is Exception && e.toString().contains('Invalid file name')),
        ),
      );
    });

    test('valid file name', () {
      expect(() => checkPath('test/inputs/OneValidJack'), returnsNormally);
    });

    test('valid 2 file names', () {
      expect(() => checkPath('test/inputs/TwoValidJacks'), returnsNormally);
    });

    test('.', () {
      expect(() => checkPath('.'), throwsException);
      expect(
        () => checkPath('.'),
        throwsA(
          predicate((e) =>
              e is Exception && e.toString().contains('No jack files found')),
        ),
      );
    });
  });

  group('File Input', () {
    test('Not exist file', () {
      expect(() => checkPath('test/inputs/NotExistJack.jack'), throwsException);
      expect(
        () => checkPath('test/inputs/NotExistJack.jack'),
        throwsA(
          predicate((e) =>
              e is Exception && e.toString().contains('File does not exist')),
        ),
      );
    });

    test('Invalid file name', () {
      expect(() => checkPath('test/inputs/InvalidFileName/invalid.jack'),
          throwsException);
      expect(
        () => checkPath('test/inputs/InvalidFileName/invalid.jack'),
        throwsA(
          predicate((e) =>
              e is Exception && e.toString().contains('Invalid file name')),
        ),
      );
    });

    test('Valid file name', () {
      expect(() => checkPath('test/inputs/OneValidJack/One.jack'),
          returnsNormally);
    });
  });
}
