import java.util.*

object CodeKt{

    @JvmStatic
    fun main(args: Array<String>) {
        val infixes = listOf("a.b.c*", "a.(b|d).c*", "(a.(b|d))*", "a.(b.b)*.c")
        val strings = listOf("", "abc", "abbc", "abcc", "abad", "abbbc")

        for (infix in infixes) {
            for (string in strings) {
                val result = matchRegex(string, infix)
                println("${if (result) "True " else "False "}$infix $string")
            }
            println()
        }
    }

    // Match the given string against the given infix regex
    private fun matchRegex(text: String, infix: String): Boolean {
        val postfix = shunt(infix)
        // Uncomment the next line to see the postfix expression
        // println("Postfix: $postfix")

        val nfa = compileRegex(postfix)

        var current = followes(nfa.initial)
        val nextStates = mutableSetOf<State>()

        for (ch in text) {
            for (state in current) {
                if (state.label == ch) {
                    val follow = followes(state.edge1)
                    nextStates.addAll(follow)
                }
            }
            current = HashSet(nextStates)
            nextStates.clear()
        }

        return current.contains(nfa.accept)
    }

    // Compile the given postfix regex into an NFA
    private fun compileRegex(postfix: String): NFA {
        val nfaStack = Stack<NFA>()

        for (ch in postfix) {
            when (ch) {
                '*' -> {
                    val nfa1 = nfaStack.pop()
                    val initial = State()
                    val accept = State()
                    initial.edge1 = nfa1.initial
                    initial.edge2 = accept
                    nfa1.accept.edge1 = nfa1.initial
                    nfa1.accept.edge2 = accept
                    nfaStack.push(NFA(initial, accept))
                }
                '.' -> {
                    val nfa2 = nfaStack.pop()
                    val nfa1 = nfaStack.pop()
                    nfa1.accept.edge1 = nfa2.initial
                    nfaStack.push(NFA(nfa1.initial, nfa2.accept))
                }
                '|' -> {
                    val nfa2 = nfaStack.pop()
                    val nfa1 = nfaStack.pop()
                    val initial = State()
                    val accept = State()
                    initial.edge1 = nfa1.initial
                    initial.edge2 = nfa2.initial
                    nfa1.accept.edge1 = accept
                    nfa2.accept.edge1 = accept
                    nfaStack.push(NFA(initial, accept))
                }
                '+' -> {
                    val nfa1 = nfaStack.pop()
                    val initial = State()
                    val accept = State()
                    initial.edge1 = nfa1.initial
                    nfa1.accept.edge1 = nfa1.initial
                    nfa1.accept.edge2 = accept
                    nfaStack.push(NFA(initial, accept))
                }
                '?' -> {
                    val nfa1 = nfaStack.pop()
                    val initial = State()
                    val accept = State()
                    initial.edge1 = nfa1.initial
                    initial.edge2 = accept
                    nfa1.accept.edge1 = accept
                    nfaStack.push(NFA(initial, accept))
                }
                else -> { // Literal character
                    val initial = State(ch)
                    val accept = State()
                    initial.edge1 = accept
                    nfaStack.push(NFA(initial, accept))
                }
            }
        }

        return nfaStack.peek()
    }

    // Compute the epsilon closure of the given state
    private fun followes(state: State?): Set<State> {
        val states = mutableSetOf<State>()
        val stack = Stack<State>()
        state?.let { stack.push(it) }

        while (stack.isNotEmpty()) {
            val current = stack.pop()
            if (!states.contains(current)) {
                states.add(current)
                if (current.label == '\u0000') { // Epsilon transition
                    current.edge1?.let { stack.push(it) }
                    current.edge2?.let { stack.push(it) }
                }
            }
        }

        return states
    }

    // Convert the given infix regex to postfix regex using the Shunting Yard algorithm
    private fun shunt(infix: String): String {
        val specials = mapOf(
            '*' to 60,
            '+' to 55,
            '?' to 50,
            '.' to 40,
            '|' to 20
        )

        val stack = Stack<Char>()
        val postfix = StringBuilder()

        for (ch in infix) {
            when (ch) {
                '(' -> stack.push(ch)
                ')' -> {
                    while (stack.isNotEmpty() && stack.peek() != '(') {
                        postfix.append(stack.pop())
                    }
                    if (stack.isNotEmpty()) {
                        stack.pop() // Remove '('
                    }
                }
                in specials -> {
                    while (stack.isNotEmpty() && stack.peek() in specials &&
                        specials[ch]!! <= specials[stack.peek()]!!) {
                        postfix.append(stack.pop())
                    }
                    stack.push(ch)
                }
                else -> postfix.append(ch)
            }
        }

        while (stack.isNotEmpty()) {
            postfix.append(stack.pop())
        }

        return postfix.toString()
    }

    private class State(val label: Char = '\u0000') {
        var edge1: State? = null // First transition
        var edge2: State? = null // Second transition
    }

    private class NFA(val initial: State, val accept: State)
}
