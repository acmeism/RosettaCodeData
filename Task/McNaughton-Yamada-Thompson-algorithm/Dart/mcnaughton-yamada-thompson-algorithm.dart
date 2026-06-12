import 'dart:collection';

void main() {
  List<String> infixes = ["a.b.c*", "a.(b|d).c*", "(a.(b|d))*", "a.(b.b)*.c"];
  List<String> strings = ["", "abc", "abbc", "abcc", "abad", "abbbc"];

  for (String infix in infixes) {
    for (String string in strings) {
      final bool result = matchRegex(string, infix);
      print("${result ? 'True ' : 'False '} $infix $string");
    }
    print("");
  }
}

// Match the given string against the given infix regex
bool matchRegex(String text, String infix) {
  String postfix = shunt(infix);
  // Uncomment the next line to see the postfix expression
  // print("Postfix: $postfix");

  NFA nfa = compileRegex(postfix);

  Set<State> current = followes(nfa.initial);
  Set<State> nextStates = {};

  for (int i = 0; i < text.length; i++) {
    final ch = text[i];
    for (State state in current) {
      if (state.label == ch) {
        // Fix: state.edge1 is nullable (State?), but followes expects a non-nullable State.
        // Add a null check before passing it.
        if (state.edge1 != null) {
          Set<State> follow = followes(state.edge1!);
          nextStates.addAll(follow);
        }
      }
    }
    current = Set<State>.from(nextStates);
    nextStates.clear();
  }

  return current.contains(nfa.accept);
}

// Compile the given postfix regex into an NFA
NFA compileRegex(String postfix) {
  List<NFA> nfaStack = [];

  for (int i = 0; i < postfix.length; i++) {
    final ch = postfix[i];
    switch (ch) {
      case '*':
        {
          NFA nfa1 = nfaStack.removeLast();
          State initial = State();
          State accept = State();
          initial.edge1 = nfa1.initial;
          initial.edge2 = accept;
          nfa1.accept.edge1 = nfa1.initial;
          nfa1.accept.edge2 = accept;
          nfaStack.add(NFA(initial, accept));
        }
        break;
      case '.':
        {
          NFA nfa2 = nfaStack.removeLast();
          NFA nfa1 = nfaStack.removeLast();
          nfa1.accept.edge1 = nfa2.initial;
          nfaStack.add(NFA(nfa1.initial, nfa2.accept));
        }
        break;
      case '|':
        {
          NFA nfa2 = nfaStack.removeLast();
          NFA nfa1 = nfaStack.removeLast();
          State initial = State();
          State accept = State();
          initial.edge1 = nfa1.initial;
          initial.edge2 = nfa2.initial;
          nfa1.accept.edge1 = accept;
          nfa2.accept.edge1 = accept;
          nfaStack.add(NFA(initial, accept));
        }
        break;
      case '+':
        {
          NFA nfa1 = nfaStack.removeLast();
          State initial = State();
          State accept = State();
          initial.edge1 = nfa1.initial;
          nfa1.accept.edge1 = nfa1.initial;
          nfa1.accept.edge2 = accept;
          nfaStack.add(NFA(initial, accept));
        }
        break;
      case '?':
        {
          NFA nfa1 = nfaStack.removeLast();
          State initial = State();
          State accept = State();
          initial.edge1 = nfa1.initial;
          initial.edge2 = accept;
          nfa1.accept.edge1 = accept;
          nfaStack.add(NFA(initial, accept));
        }
        break;
      default:
        {
          // Literal character
          State initial = State(ch);
          State accept = State();
          initial.edge1 = accept;
          nfaStack.add(NFA(initial, accept));
        }
        break;
    }
  }

  return nfaStack.last;
}

// Compute the epsilon closure of the given state
Set<State> followes(State state) {
  Set<State> states = {};
  List<State> stack = [];
  stack.add(state);

  while (stack.isNotEmpty) {
    State current = stack.removeLast();
    if (!states.contains(current)) {
      states.add(current);
      if (current.label == '\u0000') {
        // Epsilon transition
        if (current.edge1 != null) {
          stack.add(current.edge1!);
        }
        if (current.edge2 != null) {
          stack.add(current.edge2!);
        }
      }
    }
  }

  return states;
}

// Convert the given infix regex to postfix regex using the Shunting Yard algorithm
String shunt(String infix) {
  Map<String, int> specials = {
    '*': 60,
    '+': 55,
    '?': 50,
    '.': 40,
    '|': 20,
  };

  List<String> stack = [];
  String postfix = "";

  for (int i = 0; i < infix.length; i++) {
    final ch = infix[i];
    if (ch == '(') {
      stack.add(ch);
    } else if (ch == ')') {
      while (stack.isNotEmpty && stack.last != '(') {
        postfix += stack.removeLast();
      }
      if (stack.isNotEmpty) {
        stack.removeLast(); // Remove '('
      }
    } else if (specials.containsKey(ch)) {
      while (stack.isNotEmpty &&
          specials.containsKey(stack.last) &&
          specials[ch]! <= specials[stack.last]!) {
        postfix += stack.removeLast();
      }
      stack.add(ch);
    } else {
      postfix += ch;
    }
  }

  while (stack.isNotEmpty) {
    postfix += stack.removeLast();
  }

  return postfix;
}

class State {
  State([this.label = '\u0000']);

  State? edge1; // First transition
  State? edge2; // Second transition

  final String label; // Character label, '\u0000' for epsilon

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is State && runtimeType == other.runtimeType && label == other.label;

  @override
  int get hashCode => label.hashCode;
}

class NFA {
  NFA(this.initial, this.accept);

  final State initial;
  final State accept;
}
