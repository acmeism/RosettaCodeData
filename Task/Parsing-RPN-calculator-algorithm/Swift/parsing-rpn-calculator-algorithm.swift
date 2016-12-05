let opa = [
    "^": (prec: 4, rAssoc: true),
    "*": (prec: 3, rAssoc: false),
    "/": (prec: 3, rAssoc: false),
    "+": (prec: 2, rAssoc: false),
    "-": (prec: 2, rAssoc: false),
]

func rpn(tokens: [String]) -> [String] {
    var rpn : [String] = []
    var stack : [String] = [] // holds operators and left parenthesis

    for tok in tokens {
        switch tok {
        case "(":
            stack += [tok] // push "(" to stack
        case ")":
            while !stack.isEmpty {
                let op = stack.removeLast() // pop item from stack
                if op == "(" {
                    break // discard "("
                } else {
                    rpn += [op] // add operator to result
                }
            }
        default:
            if let o1 = opa[tok] { // token is an operator?
                for op in stack.reverse() {
                    if let o2 = opa[op] {
                        if !(o1.prec > o2.prec || (o1.prec == o2.prec && o1.rAssoc)) {
                            // top item is an operator that needs to come off
                            rpn += [stack.removeLast()] // pop and add it to the result
                            continue
                        }
                    }
                    break
                }

                stack += [tok] // push operator (the new one) to stack
            } else { // token is not an operator
                rpn += [tok] // add operand to result
            }
        }
    }

    return rpn + stack.reverse()
}

func parseInfix(e: String) -> String {
    let tokens = e.characters.split{ $0 == " " }.map(String.init)
    return rpn(tokens).joinWithSeparator(" ")
}

var input : String

input = "3 + 4 * 2 / ( 1 - 5 ) ^ 2 ^ 3"
"infix: \(input)"
"postfix: \(parseInfix(input))"
