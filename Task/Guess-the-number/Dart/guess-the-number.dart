import 'dart:math';
import 'dart:io';

main() {
  final n = (1 + new Random().nextInt(10)).toString();
  print("Guess which number I've chosen in the range 1 to 10");
  do { stdout.write(" Your guess : "); } while (n != stdin.readLineSync());
  print("\nWell guessed!");
}
