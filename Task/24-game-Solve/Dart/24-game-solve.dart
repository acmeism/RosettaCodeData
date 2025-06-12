enum Operator {
  Sub,
  Plus,
  Mul,
  Div
}

class Factor {
  String content;
  int value;

  Factor({this.content, this.value});

  Factor copyWith({String content, int value}) {
    return Factor(
      content: content ?? this.content,
      value: value ?? this.value
    );
  }
}

List<Factor> apply(Operator op, List<Factor> left, List<Factor> right) {
  List<Factor> ret = [];
  for (var l in left) {
    for (var r in right) {
      switch (op) {
        case Operator.Sub:
          if (l.value > r.value) {
            ret.add(Factor(
              content: "(${l.content} - ${r.content})",
              value: l.value - r.value
            ));
          }
          break;
        case Operator.Plus:
          ret.add(Factor(
            content: "(${l.content} + ${r.content})",
            value: l.value + r.value
          ));
          break;
        case Operator.Mul:
          ret.add(Factor(
            content: "(${l.content} × ${r.content})",
            value: l.value * r.value
          ));
          break;
        case Operator.Div:
          if (l.value >= r.value && r.value > 0 && l.value % r.value == 0) {
            ret.add(Factor(
              content: "(${l.content} / ${r.content})",
              value: l.value ~/ r.value
            ));
          }
          break;
      }
    }
  }
  return ret;
}

List<Factor> calc(List<Operator> op, List<int> numbers) {
  List<Factor> _calc(List<Operator> op, List<int> numbers, List<Factor> acc) {
    if (op.isEmpty) {
      return List<Factor>.from(acc);
    }

    List<Factor> ret = [];
    var monoFactor = [Factor(
      content: numbers[0].toString(),
      value: numbers[0],
    )];

    switch (op[0]) {
      case Operator.Mul:
        ret.addAll(apply(op[0], acc, monoFactor));
        break;
      case Operator.Div:
        ret.addAll(apply(op[0], acc, monoFactor));
        ret.addAll(apply(op[0], monoFactor, acc));
        break;
      case Operator.Sub:
        ret.addAll(apply(op[0], acc, monoFactor));
        ret.addAll(apply(op[0], monoFactor, acc));
        break;
      case Operator.Plus:
        ret.addAll(apply(op[0], acc, monoFactor));
        break;
    }

    return _calc(
      op.sublist(1),
      numbers.sublist(1),
      ret
    );
  }

  return _calc(
    op,
    numbers.sublist(1),
    [Factor(content: numbers[0].toString(), value: numbers[0])]
  );
}

List<Factor> solutions(List<int> numbers) {
  List<Factor> ret = [];
  Set<String> hashSet = {};

  for (var ops in OpIter()) {
    for (var order in orders()) {
      var orderedNumbers = applyOrder(numbers, order);
      var results = calc(ops, orderedNumbers);

      for (var factor in results) {
        if (factor.value == 24 && !hashSet.contains(factor.content)) {
          hashSet.add(factor.content);
          ret.add(factor);
        }
      }
    }
  }

  return ret;
}

class OpIter extends Iterable<List<Operator>> {
  @override
  Iterator<List<Operator>> get iterator => _OpIterator();
}

class _OpIterator implements Iterator<List<Operator>> {
  int _index = 0;
  static const List<Operator> OPTIONS = [
    Operator.Mul,
    Operator.Sub,
    Operator.Plus,
    Operator.Div
  ];

  @override
  List<Operator> get current {
    final f1 = OPTIONS[(_index & (3 << 4)) >> 4];
    final f2 = OPTIONS[(_index & (3 << 2)) >> 2];
    final f3 = OPTIONS[(_index & 3)];
    return [f1, f2, f3];
  }

  @override
  bool moveNext() {
    if (_index >= 1 << 6) {
      return false;
    }
    _index++;
    return true;
  }
}

List<List<int>> orders() {
  return [
    [0, 1, 2, 3],
    [0, 1, 3, 2],
    [0, 2, 1, 3],
    [0, 2, 3, 1],
    [0, 3, 1, 2],
    [0, 3, 2, 1],
    [1, 0, 2, 3],
    [1, 0, 3, 2],
    [1, 2, 0, 3],
    [1, 2, 3, 0],
    [1, 3, 0, 2],
    [1, 3, 2, 0],
    [2, 0, 1, 3],
    [2, 0, 3, 1],
    [2, 1, 0, 3],
    [2, 1, 3, 0],
    [2, 3, 0, 1],
    [2, 3, 1, 0],
    [3, 0, 1, 2],
    [3, 0, 2, 1],
    [3, 1, 0, 2],
    [3, 1, 2, 0],
    [3, 2, 0, 1],
    [3, 2, 1, 0]
  ];
}

List<int> applyOrder(List<int> numbers, List<int> order) {
  return [
    numbers[order[0]],
    numbers[order[1]],
    numbers[order[2]],
    numbers[order[3]]
  ];
}

void main(List<String> args) {
  List<int> numbers = [];

  if (args.isNotEmpty) {
    String input = args[0];
    for (var char in input.split('')) {
      int n = int.tryParse(char);
      if (n != null) {
        numbers.add(n);
      }

      if (numbers.length == 4) {
        var sols = solutions(numbers);
        var len = sols.length;

        if (len == 0) {
          print('no solution for ${numbers[0]}, ${numbers[1]}, ${numbers[2]}, ${numbers[3]}');
          return;
        }

        print('solutions for ${numbers[0]}, ${numbers[1]}, ${numbers[2]}, ${numbers[3]}');
        for (var s in sols) {
          print(s.content);
        }
        print('$len solutions found');
        return;
      }
    }
  } else {
    print('empty input');
  }
}
