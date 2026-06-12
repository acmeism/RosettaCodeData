class State:
    def __init__(self, label=None):
        self.label = label  # Character label, None for epsilon
        self.edge1 = None   # First transition
        self.edge2 = None   # Second transition

class NFA:
    def __init__(self, initial=None, accept=None):
        self.initial = initial
        self.accept = accept

def shunt(infix):
    specials = {
        '*': 60,
        '+': 55,
        '?': 50,
        '.': 40,
        '|': 20
    }
    postfix = ''
    stack = []

    for c in infix:
        if c == '(':
            stack.append(c)
        elif c == ')':
            while stack and stack[-1] != '(':
                postfix += stack.pop()
            if stack:
                stack.pop()  # Remove '('
        elif c in specials:
            while stack and stack[-1] in specials and specials[c] <= specials[stack[-1]]:
                postfix += stack.pop()
            stack.append(c)
        else:
            postfix += c

    while stack:
        postfix += stack.pop()

    return postfix

def followes(state):
    states = set()
    stack = [state]

    while stack:
        s = stack.pop()
        if s not in states:
            states.add(s)
            if s.label is None:  # Epsilon transition
                if s.edge1 is not None:
                    stack.append(s.edge1)
                if s.edge2 is not None:
                    stack.append(s.edge2)
    return states

def compileRegex(postfix):
    nfaStack = []

    for c in postfix:
        if c == '*':
            nfa1 = nfaStack.pop()
            initial = State()
            accept = State()
            initial.edge1 = nfa1.initial
            initial.edge2 = accept
            nfa1.accept.edge1 = nfa1.initial
            nfa1.accept.edge2 = accept
            nfaStack.append(NFA(initial, accept))
        elif c == '.':
            nfa2 = nfaStack.pop()
            nfa1 = nfaStack.pop()
            nfa1.accept.edge1 = nfa2.initial
            nfaStack.append(NFA(nfa1.initial, nfa2.accept))
        elif c == '|':
            nfa2 = nfaStack.pop()
            nfa1 = nfaStack.pop()
            initial = State()
            accept = State()
            initial.edge1 = nfa1.initial
            initial.edge2 = nfa2.initial
            nfa1.accept.edge1 = accept
            nfa2.accept.edge1 = accept
            nfaStack.append(NFA(initial, accept))
        elif c == '+':
            nfa1 = nfaStack.pop()
            initial = State()
            accept = State()
            initial.edge1 = nfa1.initial
            nfa1.accept.edge1 = nfa1.initial
            nfa1.accept.edge2 = accept
            nfaStack.append(NFA(initial, accept))
        elif c == '?':
            nfa1 = nfaStack.pop()
            initial = State()
            accept = State()
            initial.edge1 = nfa1.initial
            initial.edge2 = accept
            nfa1.accept.edge1 = accept
            nfaStack.append(NFA(initial, accept))
        else:  # Literal character
            initial = State(c)
            accept = State()
            initial.edge1 = accept
            nfaStack.append(NFA(initial, accept))

    return nfaStack.pop()

def matchRegex(infix, s):
    postfix = shunt(infix)
    # Uncomment the next line to see the postfix expression
    # print("Postfix:", postfix)

    nfa = compileRegex(postfix)

    current = set(followes(nfa.initial))
    nextStates = set()

    for c in s:
        for state in current:
            if state.label == c:
                follow = followes(state.edge1)
                nextStates.update(follow)
        current = nextStates
        nextStates = set()

    return nfa.accept in current

def main():
    infixes = ["a.b.c*", "a.(b|d).c*", "(a.(b|d))*", "a.(b.b)*.c"]
    strings = ["", "abc", "abbc", "abcc", "abad", "abbbc"]

    for infix in infixes:
        for s in strings:
            result = matchRegex(infix, s)
            print(("True " if result else "False ") + infix + " " + s)
        print()

if __name__ == "__main__":
    main()
