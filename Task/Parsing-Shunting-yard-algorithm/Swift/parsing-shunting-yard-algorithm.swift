import Foundation

// Using arrays for both stack and queue
struct Stack<T> {
    private(set) var elements = [T]()
    var isEmpty: Bool { return elements.isEmpty }

    mutating func push(newElement: T) {
        elements.append(newElement)
    }

    mutating func pop() -> T {
        return elements.removeLast()
    }

    func top() -> T? {
        return elements.last
    }
}

struct Queue<T> {
    private(set) var elements = [T]()
    var isEmpty: Bool { return elements.isEmpty }

    mutating func enqueue(newElement: T) {
        elements.append(newElement)
    }

    mutating func dequeue() -> T {
        return elements.removeFirst()
    }
}

enum Associativity { case Left, Right }

// Define abstract interface, which can be used to restrict Set extension
protocol OperatorType: Comparable, Hashable {
    var name: String { get }
    var precedence: Int { get }
    var associativity: Associativity { get }
}

struct Operator: OperatorType {
    let name: String
    let precedence: Int
    let associativity: Associativity
    // same operator names are not allowed
    var hashValue: Int { return "\(name)".hashValue }

    init(_ name: String, _ precedence: Int, _ associativity: Associativity) {
        self.name = name; self.precedence = precedence; self.associativity = associativity
    }
}

func ==(x: Operator, y: Operator) -> Bool {
    // same operator names are not allowed
    return x.name == y.name
}

func <(x: Operator, y: Operator) -> Bool {
    // compare operators by their precedence and associavity
    return (x.associativity == .Left && x.precedence == y.precedence) || x.precedence < y.precedence
}

extension Set where Element: OperatorType {
    func contains(op: String?) -> Bool {
        guard let operatorName = op else { return false }
        return contains { $0.name == operatorName }
    }

    subscript (operatorName: String) -> Element? {
        get {
            return filter { $0.name == operatorName }.first
        }
    }
}

// Convenience
extension String {
    var isNumber: Bool { return Double(self) != nil }
}

struct ShuntingYard {
    enum Error: ErrorType {
        case MismatchedParenthesis(String)
        case UnrecognizedToken(String)
    }

    static func parse(input: String, operators: Set<Operator>) throws -> String {
        var stack = Stack<String>()
        var output = Queue<String>()
        let tokens = input.componentsSeparatedByString(" ")

        for token in tokens {
            // Wikipedia: if token is a number add it to the output queue
            if token.isNumber {
                output.enqueue(token)
            }
            // Wikipedia: else if token is a operator:
            else if operators.contains(token) {
                // Wikipedia: while there is a operator on top of the stack and has lower precedence than current operator (token)
                while operators.contains(stack.top()) && hasLowerPrecedence(token, stack.top()!, operators) {
                    // Wikipedia: pop it off to the output queue
                    output.enqueue(stack.pop())
                }
                // Wikipedia: push current operator (token) onto the operator stack
                stack.push(token)
            }
            // Wikipedia: If the token is a left parenthesis, then push it onto the stack.
            else if token == "(" {
                stack.push(token)
            }
            // Wikipedia: If the token is a right parenthesis:
            else if token == ")" {
                // Wikipedia: Until the token at the top of the stack is a left parenthesis
                while !stack.isEmpty && stack.top() != "(" {
                    // Wikipedia: pop operators off the stack onto the output queue.
                    output.enqueue(stack.pop())
                }

                // If the stack runs out, than there are mismatched parentheses.
                if stack.isEmpty {
                    throw Error.MismatchedParenthesis(input)
                }

                // Wikipedia: Pop the left parenthesis from the stack, but not onto the output queue.
                stack.pop()
            }
            // if token is not number, operator or a parenthesis, then is not recognized
            else {
                throw Error.UnrecognizedToken(token)
            }
        }

        // Wikipedia: When there are no more tokens to read:

        // Wikipedia: While there are still operator tokens in the stack:
        while operators.contains(stack.top()) {
            // Wikipedia: Pop the operator onto the output queue.
            output.enqueue(stack.pop())
        }

        // Wikipedia: If the operator token on the top of the stack is a parenthesis, then there are mismatched parentheses
        // Note: Assume that all operators has been poped onto the output queue.
        if stack.isEmpty == false {
            throw Error.MismatchedParenthesis(input)
        }

        return output.elements.joinWithSeparator(" ")
    }

    static private func containsOperator(stack: Stack<String>, _ operators: [String: NSDictionary]) -> Bool {
        guard stack.isEmpty == false else { return false }
        // Is there a matching operator in the operators set?
        return operators[stack.top()!] != nil ? true : false
    }

    static private func hasLowerPrecedence(x: String, _ y: String, _ operators: Set<Operator>) -> Bool {
        guard let first = operators[x], let second = operators[y] else { return false }
        return first < second
    }
}

let input = "3 + 4 * 2 / ( 1 - 5 ) ^ 2 ^ 3"
let operators: Set<Operator> = [
    Operator("^", 4, .Right),
    Operator("*", 3, .Left),
    Operator("/", 3, .Left),
    Operator("+", 2, .Left),
    Operator("-", 2, .Left)
]
let output = try! ShuntingYard.parse(input, operators: operators)

print("input: \(input)")
print("output: \(output)")
