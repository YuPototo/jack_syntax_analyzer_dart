import 'package:test/test.dart';
import 'package:jack_syntax_analyzer_dart/check_path.dart';

void main() {
  test('no jack file', () {
    expect(() => checkPath('integration/CheckPath/NoJack'), throwsException);
  });

  test('invalid file name', () {
    expect(() => checkPath('integration/CheckPath/InvalidFileName'),
        throwsException);
  });

  test('valid file name', () {
    expect(
        () => checkPath('integration/CheckPath/OneValidJack'), returnsNormally);
  });

  test('valid 2 file names', () {
    expect(() => checkPath('integration/CheckPath/TwoValidJacks'),
        returnsNormally);
  });
}
