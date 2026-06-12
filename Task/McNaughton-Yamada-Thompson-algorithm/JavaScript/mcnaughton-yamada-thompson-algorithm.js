class McNaughtonYamadaThompsonAlgorithm {
  static main() {
    const infixes = ["a.b.c*", "a.(b|d).c*", "(a.(b|d))*", "a.(b.b)*.c"];
    const strings = ["", "abc", "abbc", "abcc", "abad", "abbbc"];

    for (const infix of infixes) {
      for (const string of strings) {
        const result = McNaughtonYamadaThompsonAlgorithm.matchRegex(string, infix);
        console.log(`${result ? "True" : "False"} ${infix} ${string}`);
      }
      console.log();
    }
  }

  static matchRegex(text, infix) {
    const postfix = McNaughtonYamadaThompsonAlgorithm.shunt(infix);
    // Uncomment the next line to see the postfix expression
    // console.log("Postfix: " + postfix);

    const nfa = McNaughtonYamadaThompsonAlgorithm.compileRegex(postfix);

    let current = McNaughtonYamadaThompsonAlgorithm.followes(nfa.initial);
    let nextStates = new Set();

    for (const ch of text) {
      for (const state of current) {
        if (state.label === ch) {
          const follow = McNaughtonYamadaThompsonAlgorithm.followes(state.edge1);
          for (const f of follow) {
            nextStates.add(f);
          }
        }
      }
      current = new Set(nextStates);
      nextStates.clear();
    }

    return current.has(nfa.accept);
  }

  static compileRegex(postfix) {
    const nfaStack = [];

    for (const ch of postfix) {
      switch (ch) {
        case '*': {
          const nfa1 = nfaStack.pop();
          const initial = new State();
          const accept = new State();
          initial.edge1 = nfa1.initial;
          initial.edge2 = accept;
          nfa1.accept.edge1 = nfa1.initial;
          nfa1.accept.edge2 = accept;
          nfaStack.push(new NFA(initial, accept));
          break;
        }
        case '.': {
          const nfa2 = nfaStack.pop();
          const nfa1 = nfaStack.pop();
          nfa1.accept.edge1 = nfa2.initial;
          nfaStack.push(new NFA(nfa1.initial, nfa2.accept));
          break;
        }
        case '|': {
          const nfa2 = nfaStack.pop();
          const nfa1 = nfaStack.pop();
          const initial = new State();
          const accept = new State();
          initial.edge1 = nfa1.initial;
          initial.edge2 = nfa2.initial;
          nfa1.accept.edge1 = accept;
          nfa2.accept.edge1 = accept;
          nfaStack.push(new NFA(initial, accept));
          break;
        }
        case '+': {
          const nfa1 = nfaStack.pop();
          const initial = new State();
          const accept = new State();
          initial.edge1 = nfa1.initial;
          nfa1.accept.edge1 = nfa1.initial;
          nfa1.accept.edge2 = accept;
          nfaStack.push(new NFA(initial, accept));
          break;
        }
        case '?': {
          const nfa1 = nfaStack.pop();
          const initial = new State();
          const accept = new State();
          initial.edge1 = nfa1.initial;
          initial.edge2 = accept;
          nfa1.accept.edge1 = accept;
          nfaStack.push(new NFA(initial, accept));
          break;
        }
        default: {
          const initial = new State(ch);
          const accept = new State();
          initial.edge1 = accept;
          nfaStack.push(new NFA(initial, accept));
          break;
        }
      }
    }

    return nfaStack.pop();
  }

  static followes(state) {
    const states = new Set();
    const stack = [state];

    while (stack.length > 0) {
      const current = stack.pop();
      if (!states.has(current)) {
        states.add(current);
        if (current.label === '\0') {
          if (current.edge1) stack.push(current.edge1);
          if (current.edge2) stack.push(current.edge2);
        }
      }
    }

    return states;
  }

  static shunt(infix) {
    const specials = { '*': 60, '+': 55, '?': 50, '.': 40, '|': 20 };
    const stack = [];
    let postfix = "";

    for (const ch of infix) {
      if (ch === '(') {
        stack.push(ch);
      } else if (ch === ')') {
        while (stack.length > 0 && stack[stack.length - 1] !== '(') {
          postfix += stack.pop();
        }
        if (stack.length > 0) {
          stack.pop(); // Remove '('
        }
      } else if (specials[ch]) {
        while (stack.length > 0 && specials[stack[stack.length - 1]] &&
          specials[ch] <= specials[stack[stack.length - 1]]) {
          postfix += stack.pop();
        }
        stack.push(ch);
      } else {
        postfix += ch;
      }
    }

    while (stack.length > 0) {
      postfix += stack.pop();
    }

    return postfix;
  }
}

class State {
  constructor(label = '\0') {
    this.label = label;
    this.edge1 = null;
    this.edge2 = null;
  }
}

class NFA {
  constructor(initial, accept) {
    this.initial = initial;
    this.accept = accept;
  }
}

// Run the main method
McNaughtonYamadaThompsonAlgorithm.main();
