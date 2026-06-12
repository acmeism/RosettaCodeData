void main() {
  List<int> result = [];
  int number = 3;

  while (result.length < 7) {
    int collatz = number;

    while (collatz != 1) {
      collatz = (collatz % 2 == 0) ? collatz ~/ 2 : 3 * collatz + 1;

      if (collatz % number == 0) {
        result.add(number);
        collatz = 1; // Para salir del while interno
      }
    }

    number += 2; // Solo impares
  }

  print("The first seven self-contained numbers are: ${result.join(' ')}");
}
