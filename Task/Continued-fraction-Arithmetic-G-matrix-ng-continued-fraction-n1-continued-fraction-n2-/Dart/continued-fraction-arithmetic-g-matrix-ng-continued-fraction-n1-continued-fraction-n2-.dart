import 'dart:math';
import 'dart:io';

void main() {
  test("[3; 7] + [0; 2]",
      [
        NG(NG8(0, 1, 1, 0, 0, 0, 0, 1), [R2cf(1, 2), R2cf(22, 7)]),
        NG(NG4(2, 1, 0, 2), [R2cf(22, 7)])
      ]);

  test("[1; 5, 2] * [3; 7]",
      [
        NG(NG8(1, 0, 0, 0, 0, 0, 0, 1), [R2cf(13, 11), R2cf(22, 7)]),
        R2cf(286, 77)
      ]);

  test("[1; 5, 2] - [3; 7]",
      [
        NG(NG8(0, 1, -1, 0, 0, 0, 0, 1), [R2cf(13, 11), R2cf(22, 7)]),
        R2cf(-151, 77)
      ]);

  test("Divide [] by [3; 7]",
      [
        NG(NG8(0, 1, 0, 0, 0, 0, 1, 0), [R2cf(22 * 22, 7 * 7), R2cf(22, 7)])
      ]);

  test("([0; 3, 2] + [1; 5, 2]) * ([0; 3, 2] - [1; 5, 2])",
      [
        NG(
            NG8(1, 0, 0, 0, 0, 0, 0, 1),
            [
              NG(NG8(0, 1, 1, 0, 0, 0, 0, 1), [R2cf(2, 7), R2cf(13, 11)]),
              NG(NG8(0, 1, -1, 0, 0, 0, 0, 1), [R2cf(2, 7), R2cf(13, 11)])
            ]),
        R2cf(-7797, 5929)
      ]);
}

void test(String description, List<ContinuedFraction> fractions) {
  print("Testing: $description");
  for (var fraction in fractions) {
    while (fraction.hasMoreTerms()) {
      stdout.write("${fraction.nextTerm()} ");
    }
    print("");
  }
  print("");
}

abstract class MatrixNG {
  void consumeTerm();
  void consumeTermWithN(int n);
  bool needsTerm();

  int configuration = 0;
  int currentTerm = 0;
  bool hasTerm = false;
}

class NG4 extends MatrixNG {
  late int a1, a, b1, b;

  NG4(int aA1, int aA, int aB1, int aB) {
    a1 = aA1;
    a = aA;
    b1 = aB1;
    b = aB;
  }

  @override
  void consumeTerm() {
    a = a1;
    b = b1;
  }

  @override
  void consumeTermWithN(int n) {
    int temp = a;
    a = a1;
    a1 = temp + a1 * n;
    temp = b;
    b = b1;
    b1 = temp + b1 * n;
  }

  @override
  bool needsTerm() {
    if (b1 == 0 && b == 0) {
      return false;
    }
    if (b1 == 0 || b == 0) {
      return true;
    }

    currentTerm = a ~/ b;
    if (currentTerm == a1 ~/ b1) {
      int temp = a;
      a = b;
      b = temp - b * currentTerm;
      temp = a1;
      a1 = b1;
      b1 = temp - b1 * currentTerm;

      hasTerm = true;
      return false;
    }
    return true;
  }
}

class NG8 extends MatrixNG {
  late int a12, a1, a2, a, b12, b1, b2, b;
  late double ab, a1b1, a2b2, a12b12;

  NG8(int aA12, int aA1, int aA2, int aA, int aB12, int aB1, int aB2, int aB) {
    a12 = aA12;
    a1 = aA1;
    a2 = aA2;
    a = aA;
    b12 = aB12;
    b1 = aB1;
    b2 = aB2;
    b = aB;
  }

  @override
  void consumeTerm() {
    if (configuration == 0) {
      a = a1;
      a2 = a12;
      b = b1;
      b2 = b12;
    } else {
      a = a2;
      a1 = a12;
      b = b2;
      b1 = b12;
    }
  }

  @override
  void consumeTermWithN(int n) {
    if (configuration == 0) {
      int temp = a;
      a = a1;
      a1 = temp + a1 * n;
      temp = a2;
      a2 = a12;
      a12 = temp + a12 * n;
      temp = b;
      b = b1;
      b1 = temp + b1 * n;
      temp = b2;
      b2 = b12;
      b12 = temp + b12 * n;
    } else {
      int temp = a;
      a = a2;
      a2 = temp + a2 * n;
      temp = a1;
      a1 = a12;
      a12 = temp + a12 * n;
      temp = b;
      b = b2;
      b2 = temp + b2 * n;
      temp = b1;
      b1 = b12;
      b12 = temp + b12 * n;
    }
  }

  @override
  bool needsTerm() {
    if (b1 == 0 && b == 0 && b2 == 0 && b12 == 0) {
      return false;
    }

    if (b == 0) {
      configuration = (b2 == 0) ? 0 : 1;
      return true;
    }
    ab = a / b;

    if (b2 == 0) {
      configuration = 1;
      return true;
    }
    a2b2 = a2 / b2;

    if (b1 == 0) {
      configuration = 0;
      return true;
    }
    a1b1 = a1 / b1;

    if (b12 == 0) {
      configuration = _setConfiguration();
      return true;
    }
    a12b12 = a12 / b12;

    currentTerm = ab.toInt();
    if (currentTerm == a1b1.toInt() &&
        currentTerm == a2b2.toInt() &&
        currentTerm == a12b12.toInt()) {
      int temp = a;
      a = b;
      b = temp - b * currentTerm;
      temp = a1;
      a1 = b1;
      b1 = temp - b1 * currentTerm;
      temp = a2;
      a2 = b2;
      b2 = temp - b2 * currentTerm;
      temp = a12;
      a12 = b12;
      b12 = temp - b12 * currentTerm;

      hasTerm = true;
      return false;
    }
    configuration = _setConfiguration();
    return true;
  }

  int _setConfiguration() {
    return (a1b1 - ab).abs() > (a2b2 - ab).abs() ? 0 : 1;
  }
}

abstract class ContinuedFraction {
  bool hasMoreTerms();
  int nextTerm();
}

class R2cf implements ContinuedFraction {
  late int n1, n2;

  R2cf(int aN1, int aN2) {
    n1 = aN1;
    n2 = aN2;
  }

  @override
  bool hasMoreTerms() {
    return n2.abs() > 0;
  }

  @override
  int nextTerm() {
    final term = n1 ~/ n2;
    final temp = n2;
    n2 = n1 - term * n2;
    n1 = temp;
    return term;
  }
}

class NG implements ContinuedFraction {
  late MatrixNG matrixNG;
  late List<ContinuedFraction> cf;

  NG(MatrixNG aNG, List<ContinuedFraction> aCF) {
    matrixNG = aNG;
    cf = aCF;
  }

  @override
  bool hasMoreTerms() {
    while (matrixNG.needsTerm()) {
      if (cf[matrixNG.configuration].hasMoreTerms()) {
        matrixNG.consumeTermWithN(cf[matrixNG.configuration].nextTerm());
      } else {
        matrixNG.consumeTerm();
      }
    }
    return matrixNG.hasTerm;
  }

  @override
  int nextTerm() {
    matrixNG.hasTerm = false;
    return matrixNG.currentTerm;
  }
}
