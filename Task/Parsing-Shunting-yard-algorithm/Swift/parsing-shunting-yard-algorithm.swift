// Updated to Swift 5.7
import Foundation

// Using arrays for both stack and queue
struct Stack<T> {
	private(set) var elements = [T]()
	
	var isEmpty: Bool {
		elements.isEmpty
	}
	
	var top: T? {
		elements.last
	}
	
	mutating func push(_ newElement: T) {
		elements.append(newElement)
	}
	
	mutating func pop() -> T? {
		self.isEmpty ? nil : elements.removeLast()
	}
}

struct Queue<T> {
	private(set) var elements = [T]()
	
	var isEmpty: Bool {
		elements.isEmpty
	}
	
	mutating func enqueue(_ newElement: T) {
		elements.append(newElement)
	}
	
	mutating func dequeue() -> T {
		return elements.removeFirst()
	}
}

enum Associativity {
	case Left, Right
}

// Protocol can be used to restrict Set extension
protocol OperatorType: Comparable, Hashable {
	var name: String { get }
	var precedence: Int { get }
	var associativity: Associativity { get }
}

struct Operator: OperatorType {
	let name: String
	let precedence: Int
	let associativity: Associativity
	
	// Duplicate operator names are not allowed
	func hash(into hasher: inout Hasher) {
		hasher.combine(self.name)
	}
	
	init(_ name: String, _ precedence: Int, _ associativity: Associativity) {
		self.name = name; self.precedence = precedence; self.associativity = associativity
	}
}

func ==(x: Operator, y: Operator) -> Bool {
	// Identified by name
	x.name == y.name
}

func <(x: Operator, y: Operator) -> Bool {
	// Take precedence and associavity into account
	(x.associativity == .Left && x.precedence == y.precedence) || x.precedence < y.precedence
}

extension Set where Element: OperatorType {
	func contains(_ operatorName: String) -> Bool {
		contains { $0.name == operatorName }
	}
	
	subscript (operatorName: String) -> Element? {
		get {
			filter { $0.name == operatorName }.first
		}
	}
}

// Convenience
extension String {
	var isNumber: Bool { return Double(self) != nil }
}

struct ShuntingYard {
	enum ParseError: Error {
		case MismatchedParenthesis(parenthesis: String, expression: String)
		case UnrecognizedToken(token: String, expression: String)
		case ExtraneousToken(token: String, expression: String)
	}
	
	static func parse(_ input: String, operators: Set<Operator>) throws -> String {
		var stack = Stack<String>()
		var output = Queue<String>()
		let tokens = input.components(separatedBy: " ")
		
		for token in tokens {
			// Number?
			if token.isNumber {
				// Add it to the output queue
				output.enqueue(token)
				continue
			}
			
			// Operator?
			if operators.contains(token) {
				// While there is a operator on top of the stack and has lower precedence than current operator (token)
				while let top = stack.top,
					  operators.contains(top) && Self.hasLowerPrecedence(token, top, operators) {
					// Pop it off to the output queue
					output.enqueue(stack.pop()!)
				}
				// Push current operator (token) onto the operator stack
				stack.push(token)
				continue
			}
			
			// Left parenthesis?
			if token == "(" {
				//  Push it onto the stack
				stack.push(token)
				continue
			}
			
			// Right parenthesis?
			if token == ")" {
				// Until the token at the top of the stack is a left parenthesis
				while let top = stack.top, top != "(" {
					// Pop operators off the stack onto the output queue.
					output.enqueue(stack.pop()!)
				}
				
				// Pop the left parenthesis from the stack without putting it onto the output queue
				guard let _ = stack.pop() else {
					// If the stack runs out, than there is no matching left parenthesis
					throw ParseError.MismatchedParenthesis(parenthesis: ")", expression: input)
				}
				
				continue
			}
			
			// Token not recognized!
			throw ParseError.UnrecognizedToken(token: token, expression: token)
		}
		
		// No more tokens
		
		// Still operators on the stack?
		while let top = stack.top,
			  operators.contains(top) {
			// Put them onto the output queue
			output.enqueue(stack.pop()!)
		}
		
		// If the top of the stack is a (left) parenthesis, then there is no matching right parenthesis
		// Note: Assume that all operators has been popped and put onto the output queue
		if let top = stack.pop() {
			throw (
				top == "("
				? ParseError.MismatchedParenthesis(parenthesis: "(", expression: input)
				: ParseError.ExtraneousToken(token: top, expression: input)
			)
		}
		
		return output.elements.joined(separator: " ")
	}
	
	static private func hasLowerPrecedence(_ firstToken: String, _ secondToken: String, _ operators: Set<Operator>) -> Bool {
		guard let firstOperator = operators[firstToken],
			  let secondOperator = operators[secondToken] else {
			return false
		}
		
		return firstOperator < secondOperator
	}
}

/* Include in tests
func testParse() throws {
	let input = "3 + 4 * 2 / ( 1 - 5 ) ^ 2 ^ 3"
	let operators: Set<Operator> = [
		Operator("^", 4, .Right),
		Operator("*", 3, .Left),
		Operator("/", 3, .Left),
		Operator("+", 2, .Left),
		Operator("-", 2, .Left)
	]
	let output = try! ShuntingYard.parse(input, operators: operators)
	XCTAssertEqual(output, "3 4 2 * 1 5 - 2 3 ^ ^ / +")
}
*/
