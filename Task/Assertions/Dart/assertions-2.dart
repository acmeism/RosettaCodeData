import 'package:test/test.dart';

main() {
  int i=42;
  int j=41;

  test('i equals 42?', (){
    expect( i, equals(42) );
  });

  test('j equals 42?', (){
    expect( j, equals(42) );
  });
}
