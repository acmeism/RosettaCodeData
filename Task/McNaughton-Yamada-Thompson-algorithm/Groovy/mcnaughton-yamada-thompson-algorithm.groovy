class McNaughtonYamadaThompsonAlgorithm {

    static void main(String[] args) {
        def infixes = ["a.b.c*", "a.(b|d).c*", "(a.(b|d))*", "a.(b.b)*.c"]
        def strings = ["", "abc", "abbc", "abcc", "abad", "abbbc"]

        infixes.each { infix ->
            strings.each { string ->
                def result = matchRegex(string, infix)
                println("${result ? 'True ' : 'False '}${infix} ${string}")
            }
            println()
        }
    }

    // Match the given string against the given infix regex
    static boolean matchRegex(String text, String infix) {
        def postfix = shunt(infix)
        // Uncomment the next line to see the postfix expression
        // println("Postfix: ${postfix}")

        def nfa = compileRegex(postfix)

        def current = followes(nfa.initial)
        def nextStates = [] as Set

        text.each { ch ->
            current.each { state ->
                if (state.label == ch as char) {
                    def follow = followes(state.edge1)
                    nextStates.addAll(follow)
                }
            }
            current = new HashSet(nextStates)
            nextStates.clear()
        }

        return current.contains(nfa.accept)
    }

    // Compile the given postfix regex into an NFA
    static NFA compileRegex(String postfix) {
        def nfaStack = [] as Stack

        postfix.each { ch ->
            switch (ch) {
                case '*':
                    def nfa1 = nfaStack.pop()
                    def initial = new State()
                    def accept = new State()
                    initial.edge1 = nfa1.initial
                    initial.edge2 = accept
                    nfa1.accept.edge1 = nfa1.initial
                    nfa1.accept.edge2 = accept
                    nfaStack.push(new NFA(initial, accept))
                    break
                case '.':
                    def nfa2 = nfaStack.pop()
                    def nfa1 = nfaStack.pop()
                    nfa1.accept.edge1 = nfa2.initial
                    nfaStack.push(new NFA(nfa1.initial, nfa2.accept))
                    break
                case '|':
                    def nfa2 = nfaStack.pop()
                    def nfa1 = nfaStack.pop()
                    def initial = new State()
                    def accept = new State()
                    initial.edge1 = nfa1.initial
                    initial.edge2 = nfa2.initial
                    nfa1.accept.edge1 = accept
                    nfa2.accept.edge1 = accept
                    nfaStack.push(new NFA(initial, accept))
                    break
                case '+':
                    def nfa1 = nfaStack.pop()
                    def initial = new State()
                    def accept = new State()
                    initial.edge1 = nfa1.initial
                    nfa1.accept.edge1 = nfa1.initial
                    nfa1.accept.edge2 = accept
                    nfaStack.push(new NFA(initial, accept))
                    break
                case '?':
                    def nfa1 = nfaStack.pop()
                    def initial = new State()
                    def accept = new State()
                    initial.edge1 = nfa1.initial
                    initial.edge2 = accept
                    nfa1.accept.edge1 = accept
                    nfaStack.push(new NFA(initial, accept))
                    break
                default: // Literal character
                    def initial = new State(ch as char)
                    def accept = new State()
                    initial.edge1 = accept
                    nfaStack.push(new NFA(initial, accept))
                    break
            }
        }

        return nfaStack.peek()
    }

    // Compute the epsilon closure of the given state
    static Set<State> followes(State state) {
        def states = [] as Set
        def stack = [] as Stack
        stack.push(state)

        while (!stack.isEmpty()) {
            def current = stack.pop()
            if (!states.contains(current)) {
                states.add(current)
                if (current.label == '\0') { // Epsilon transition
                    if (current.edge1 != null) {
                        stack.push(current.edge1)
                    }
                    if (current.edge2 != null) {
                        stack.push(current.edge2)
                    }
                }
            }
        }

        return states
    }

    // Convert the given infix regex to postfix regex using the Shunting Yard algorithm
    static String shunt(String infix) {
        def specials = ['*': 60, '+': 55, '?': 50, '.': 40, '|': 20]

        def stack = [] as Stack
        def postfix = ""

        infix.each { ch ->
            if (ch == '(') {
                stack.push(ch)
            } else if (ch == ')') {
                while (!stack.isEmpty() && stack.peek() != '(') {
                    postfix += stack.pop()
                }
                if (!stack.isEmpty()) {
                    stack.pop() // Remove '('
                }
            } else if (specials.containsKey(ch)) {
                while (!stack.isEmpty() && specials.containsKey(stack.peek()) &&
                       specials[ch] <= specials[stack.peek()]) {
                    postfix += stack.pop()
                }
                stack.push(ch)
            } else {
                postfix += ch
            }
        }

        while (!stack.isEmpty()) {
            postfix += stack.pop()
        }

        return postfix
    }

    static class State {

        State(char label) {
            this.label = label
        }

        State() {
            this.label = '\0'
        }

        State edge1 = null // First transition
        State edge2 = null // Second transition

        final char label   // Character label, '\0' for epsilon
    }

    static class NFA {

        NFA(State initial, State accept) {
            this.initial = initial
            this.accept = accept
        }

        State initial
        State accept
    }
}
