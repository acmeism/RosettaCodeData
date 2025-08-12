import 'dart:io';


abstract class IteratorTrait {
  bool hasNext();
  int next();
}

class CFData {
  final String text;
  final List<int> args;
  final IteratorTrait iterator;

  CFData(this.text, this.args, this.iterator);
}

class R2cfIterator implements IteratorTrait {
  int numerator;
  int denominator;

  R2cfIterator(this.numerator, this.denominator);

  @override
  bool hasNext() {
    return denominator != 0;
  }

  @override
  int next() {
    int div = numerator ~/ denominator;
    int rem = numerator % denominator;
    numerator = denominator;
    denominator = rem;
    return div;
  }
}

class Root2 implements IteratorTrait {
  bool firstReturn = true;

  @override
  bool hasNext() {
    return true;
  }

  @override
  int next() {
    if (firstReturn) {
      firstReturn = false;
      return 1;
    } else {
      return 2;
    }
  }
}

class ReciprocalRoot2 implements IteratorTrait {
  bool firstReturn = true;
  bool secondReturn = true;

  @override
  bool hasNext() {
    return true;
  }

  @override
  int next() {
    if (firstReturn) {
      firstReturn = false;
      return 0;
    } else if (secondReturn) {
      secondReturn = false;
      return 1;
    } else {
      return 2;
    }
  }
}

class NG {
  int a1;
  int a;
  int b1;
  int b;

  NG(List<int> args)
      : a1 = args[0],
        a = args[1],
        b1 = args[2],
        b = args[3];

  void ingress(int aN) {
    int temp = a;
    a = a1;
    a1 = temp + a1 * aN;
    temp = b;
    b = b1;
    b1 = temp + b1 * aN;
  }

  int egress() {
    int n = a ~/ b;
    int temp = a;
    a = b;
    b = temp - b * n;
    temp = a1;
    a1 = b1;
    b1 = temp - b1 * n;
    return n;
  }

  bool needsTerm() {
    return b == 0 || b1 == 0 || a * b1 != a1 * b;
  }

  int egressDone() {
    if (needsTerm()) {
      a = a1;
      b = b1;
    }
    return egress();
  }

  bool done() {
    return b == 0 || b1 == 0;
  }
}

void main() {
  List<CFData> cfData = [
    CFData("[1; 5, 2] + 1 / 2", [2, 1, 0, 2], R2cfIterator(13, 11)),
    CFData("[3; 7] + 1 / 2", [2, 1, 0, 2], R2cfIterator(22, 7)),
    CFData("[3; 7] divided by 4", [1, 0, 0, 4], R2cfIterator(22, 7)),
    CFData("sqrt(2)", [0, 1, 1, 0], Root2()),
    CFData("1 / sqrt(2)", [0, 1, 1, 0], ReciprocalRoot2()),
    CFData("(1 + sqrt(2)) / 2", [1, 1, 0, 2], Root2()),
    CFData("(1 + 1 / sqrt(2)) / 2", [1, 1, 0, 2], ReciprocalRoot2())
  ];

  for (var data in cfData) {
    stdout.write("${data.text} -> ");
    NG ng = NG(data.args);
    IteratorTrait iterator = data.iterator;
    int nextTerm = 0;
    for (int i = 1; i <= 20 && iterator.hasNext(); i++) {
      nextTerm = iterator.next();
      if (!ng.needsTerm()) {
        stdout.write("${ng.egress()} ");
      }
      ng.ingress(nextTerm);
    }
    while (!ng.done()) {
      stdout.write("${ng.egressDone()} ");
    }
    print("");
  }
}
