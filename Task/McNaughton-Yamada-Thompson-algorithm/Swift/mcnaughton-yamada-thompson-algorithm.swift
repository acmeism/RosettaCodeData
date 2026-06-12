import Foundation

class McNaughtonYamadaThompsonAlgorithm {

    static func main() {
        let infixes = ["a.b.c*", "a.(b|d).c*", "(a.(b|d))*", "a.(b.b)*.c"]
        let strings = ["", "abc", "abbc", "abcc", "abad", "abbbc"]

        for infix in infixes {
            for string in strings {
                let result = matchRegex(text: string, infix: infix)
                print("\(result ? "True " : "False ")\(infix) \(string)")
            }
            print()
        }
    }

    // Match the given string against the given infix regex
    private static func matchRegex(text: String, infix: String) -> Bool {
        let postfix = shunt(infix: infix)
        // Uncomment the next line to see the postfix expression
        // print("Postfix: \(postfix)")

        let nfa = compileRegex(postfix: postfix)

        var current = followes(state: nfa.initial)
        var nextStates = Set<State>()

        for ch in text {
            for state in current {
                if state.label == ch {
                    let follow = followes(state: state.edge1)
                    nextStates.formUnion(follow)
                }
            }
            current = Set(nextStates)
            nextStates.removeAll()
        }

        return current.contains(nfa.accept)
    }

    // Compile the given postfix regex into an NFA
    private static func compileRegex(postfix: String) -> NFA {
        var nfaStack: [NFA] = []

        for ch in postfix {
            switch ch {
            case "*":
                let nfa1 = nfaStack.removeLast()
                let initial = State()
                let accept = State()
                initial.edge1 = nfa1.initial
                initial.edge2 = accept
                nfa1.accept.edge1 = nfa1.initial
                nfa1.accept.edge2 = accept
                nfaStack.append(NFA(initial: initial, accept: accept))

            case ".":
                let nfa2 = nfaStack.removeLast()
                let nfa1 = nfaStack.removeLast()
                nfa1.accept.edge1 = nfa2.initial
                nfaStack.append(NFA(initial: nfa1.initial, accept: nfa2.accept))

            case "|":
                let nfa2 = nfaStack.removeLast()
                let nfa1 = nfaStack.removeLast()
                let initial = State()
                let accept = State()
                initial.edge1 = nfa1.initial
                initial.edge2 = nfa2.initial
                nfa1.accept.edge1 = accept
                nfa2.accept.edge1 = accept
                nfaStack.append(NFA(initial: initial, accept: accept))

            case "+":
                let nfa1 = nfaStack.removeLast()
                let initial = State()
                let accept = State()
                initial.edge1 = nfa1.initial
                nfa1.accept.edge1 = nfa1.initial
                nfa1.accept.edge2 = accept
                nfaStack.append(NFA(initial: initial, accept: accept))

            case "?":
                let nfa1 = nfaStack.removeLast()
                let initial = State()
                let accept = State()
                initial.edge1 = nfa1.initial
                initial.edge2 = accept
                nfa1.accept.edge1 = accept
                nfaStack.append(NFA(initial: initial, accept: accept))

            default: // Literal character
                let initial = State(label: ch)
                let accept = State()
                initial.edge1 = accept
                nfaStack.append(NFA(initial: initial, accept: accept))
            }
        }

        return nfaStack.last!
    }

    // Compute the epsilon closure of the given state
    private static func followes(state: State?) -> Set<State> {
        guard let state = state else { return Set<State>() }

        var states = Set<State>()
        var stack: [State] = [state]

        while !stack.isEmpty {
            let current = stack.removeLast()
            if !states.contains(current) {
                states.insert(current)
                if current.label == Character("\0") { // Epsilon transition
                    if let edge1 = current.edge1 {
                        stack.append(edge1)
                    }
                    if let edge2 = current.edge2 {
                        stack.append(edge2)
                    }
                }
            }
        }

        return states
    }

    // Convert the given infix regex to postfix regex using the Shunting Yard algorithm
    private static func shunt(infix: String) -> String {
        let specials: [Character: Int] = [
            "*": 60,
            "+": 55,
            "?": 50,
            ".": 40,
            "|": 20
        ]

        var stack: [Character] = []
        var postfix = ""

        for ch in infix {
            if ch == "(" {
                stack.append(ch)
            } else if ch == ")" {
                while !stack.isEmpty && stack.last != "(" {
                    postfix.append(stack.removeLast())
                }
                if !stack.isEmpty {
                    stack.removeLast() // Remove '('
                }
            } else if specials.keys.contains(ch) {
                while !stack.isEmpty &&
                      specials.keys.contains(stack.last!) &&
                      specials[ch]! <= specials[stack.last!]! {
                    postfix.append(stack.removeLast())
                }
                stack.append(ch)
            } else {
                postfix.append(ch)
            }
        }

        while !stack.isEmpty {
            postfix.append(stack.removeLast())
        }

        return postfix
    }
}

// MARK: - Supporting Classes

class State: Hashable {
    var edge1: State?
    var edge2: State?
    let label: Character
    private let id = UUID()

    init(label: Character = Character("\0")) {
        self.label = label
    }

    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }

    static func == (lhs: State, rhs: State) -> Bool {
        return lhs.id == rhs.id
    }
}

class NFA {
    let initial: State
    let accept: State

    init(initial: State, accept: State) {
        self.initial = initial
        self.accept = accept
    }
}

// Run the main function
McNaughtonYamadaThompsonAlgorithm.main()
