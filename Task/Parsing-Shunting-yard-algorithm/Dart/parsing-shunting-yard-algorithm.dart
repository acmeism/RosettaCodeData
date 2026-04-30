import 'dart:collection';

class ShuntingYard {
  static final Map<String, OperatorInfo> operators = {
    '^': OperatorInfo('^', 4, true),
    '*': OperatorInfo('*', 3, false),
    '/': OperatorInfo('/', 3, false),
    '+': OperatorInfo('+', 2, false),
    '-': OperatorInfo('-', 2, false),
  };

  static String toPostfix(String infix) {
    List<String> tokens = infix.split(' ');
    Queue<String> stack = Queue<String>();
    List<String> output = [];

    void printState(String action) {
      List<String> stackList = stack.toList();
      stackList = stackList.reversed.toList();
      print('${(action + ":").padRight(4)} ${"stack[ ${stackList.join(" ")} ]".padRight(18)} out[ ${output.join(" ")} ]');
    }

    for (String token in tokens) {
      if (isNumeric(token)) {
        output.add(token);
        printState(token);
      } else if (operators.containsKey(token)) {
        OperatorInfo op1 = operators[token]!;
        while (stack.isNotEmpty && operators.containsKey(stack.last)) {
          OperatorInfo op2 = operators[stack.last]!;
          int c = op1.precedence.compareTo(op2.precedence);
          if (c < 0 || (!op1.rightAssociative && c <= 0)) {
            output.add(stack.removeLast());
          } else {
            break;
          }
        }
        stack.add(token);
        printState(token);
      } else if (token == "(") {
        stack.add(token);
        printState(token);
      } else if (token == ")") {
        String top = "";
        while (stack.isNotEmpty && (top = stack.removeLast()) != "(") {
          output.add(top);
        }
        if (top != "(") throw ArgumentError("No matching left parenthesis.");
        printState(token);
      }
    }

    while (stack.isNotEmpty) {
      String top = stack.removeLast();
      if (!operators.containsKey(top)) throw ArgumentError("No matching right parenthesis.");
      output.add(top);
    }
    printState("pop");

    return output.join(" ");
  }

  static bool isNumeric(String str) {
    try {
      int.parse(str);
      return true;
    } catch (e) {
      return false;
    }
  }
}

class OperatorInfo {
  final String symbol;
  final int precedence;
  final bool rightAssociative;

  OperatorInfo(this.symbol, this.precedence, this.rightAssociative);
}

void main() {
  String infix = "3 + 4 * 2 / ( 1 - 5 ) ^ 2 ^ 3";
  print(ShuntingYard.toPostfix(infix));
}
