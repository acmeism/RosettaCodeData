import "./dynamic" for Struct

// label, character label - null for epsilon
// edge1, first transition
// edge2, second transition
var State = Struct.create("State", ["label", "edge1", "edge2"])

var NFA = Struct.create("NFA", ["initial", "accept"])

var shunt = Fn.new { |infix|
    var specials = { "*": 60, "+": 55, "?": 50, ".": 40, "|": 20 }
    var postfix = ""
    var stack = []
    for (c in infix) {
        if (c == "(") {
            stack.add(c)
        } else if (c == ")") {
            while (!stack.isEmpty && stack[-1] != "(") {
                postfix = postfix + stack.removeAt(-1)
            }
            if (!stack.isEmpty) stack.removeAt(-1) // Remove "("
        } else if (specials.containsKey(c)) {
            while (!stack.isEmpty && specials.containsKey(stack[-1]) &&
                   specials[c] <= specials[stack[-1]]) {
                postfix = postfix + stack.removeAt(-1)
            }
            stack.add(c)
        } else {
            postfix = postfix + c
        }
    }
    while (!stack.isEmpty) postfix = postfix + stack.removeAt(-1)
    return postfix
}

var followes = Fn.new { |state|
    var states = []
    var stack = [state]
    while (!stack.isEmpty) {
        var s = stack.removeAt(-1)
        if (!states.contains(s)) {
            states.add(s)
            if (!s.label) {  // Epsilon transition
                if (s.edge1) stack.add(s.edge1)
                if (s.edge2) stack.add(s.edge2)
            }
        }
    }
    return states
}

var compileRegex = Fn.new { |postfix|
    var nfaStack = []
    for (c in postfix) {
        if (c == "*") {
            var nfa1 = nfaStack.removeAt(-1)
            var initial = State.new(null, null, null)
            var accept  = State.new(null, null, null)
            initial.edge1 = nfa1.initial
            initial.edge2 = accept
            nfa1.accept.edge1 = nfa1.initial
            nfa1.accept.edge2 = accept
            nfaStack.add(NFA.new(initial, accept))
        } else if (c == ".") {
            var nfa2 = nfaStack.removeAt(-1)
            var nfa1 = nfaStack.removeAt(-1)
            nfa1.accept.edge1 = nfa2.initial
            nfaStack.add(NFA.new(nfa1.initial, nfa2.accept))
        } else if (c == "|") {
            var nfa2 = nfaStack.removeAt(-1)
            var nfa1 = nfaStack.removeAt(-1)
            var initial = State.new(null, null, null)
            var accept  = State.new(null, null, null)
            initial.edge1 = nfa1.initial
            initial.edge2 = nfa2.initial
            nfa1.accept.edge1 = accept
            nfa2.accept.edge1 = accept
            nfaStack.add(NFA.new(initial, accept))
        } else if (c == "+") {
            var nfa1 = nfaStack.removeAt(-1)
            var initial = State.new(null, null, null)
            var accept  = State.new(null, null, null)
            initial.edge1 = nfa1.initial
            nfa1.accept.edge1 = nfa1.initial
            nfa1.accept.edge2 = accept
            nfaStack.add(NFA.new(initial, accept))
        } else if (c == "?") {
            var nfa1 = nfaStack.removeAt(-1)
            var initial = State.new(null, null, null)
            var accept  = State.new(null, null, null)
            initial.edge1 = nfa1.initial
            initial.edge2 = accept
            nfa1.accept.edge1 = accept
            nfaStack.add(NFA.new(initial, accept))
        } else {  // Literal character
            var initial = State.new(c, null, null)
            var accept  = State.new(null, null, null)
            initial.edge1 = accept
            nfaStack.add(NFA.new(initial, accept))
        }
    }
    return nfaStack.removeAt(-1)
}

var matchRegex = Fn.new { |infix, s|
    var postfix = shunt.call(infix)
    // Uncomment the next line to see postfix expression
    // System.print("Postfix: %(postfix)")
    var nfa = compileRegex.call(postfix)
    var current = followes.call(nfa.initial)
    var nextStates = []
    for (c in s) {
        for (state in current) {
            if (state.label == c) {
                var follow = followes.call(state.edge1)
                for (st in follow) {
                   if (!nextStates.contains(st)) nextStates.add(st)
                }
            }
        }
        current = nextStates
        nextStates = []
    }
    return current.contains(nfa.accept)
}

var infixes = ["a.b.c*", "a.(b|d).c*", "(a.(b|d))*", "a.(b.b)*.c"]
var strings = ["", "abc", "abbc", "abcc", "abad", "abbbc"]

for (infix in infixes) {
    for (s in strings) {
        var result = matchRegex.call(infix, s)
        System.print((result ? "True  " : "False ") + infix + " " + s)
    }
    System.print()
}
