import ceylon.collection {

	ArrayList
}

abstract class Token(String|Integer data) of IntegerLiteral | Operator | leftParen | rightParen {
	string => data.string;
}
class IntegerLiteral(shared Integer integer) extends Token(integer) {}
class Operator  extends Token {

	shared Integer precedence;
	shared Boolean rightAssoc;
	
	shared new plus extends Token("+") {
		precedence = 2;
		rightAssoc = false;
	}
	shared new minus extends Token("-") {
		precedence = 2;
		rightAssoc = false;
	}
	shared new times extends Token("*") {
		precedence = 3;
		rightAssoc = false;
	}
	shared new divides extends Token("/") {
		precedence = 3;
		rightAssoc = false;
	}
	shared new power extends Token("^") {
		precedence = 4;
		rightAssoc = true;
	}

	shared Boolean below(Operator other) =>
			!rightAssoc && precedence <= other.precedence || rightAssoc && precedence < other.precedence;
}
object leftParen extends Token("(") {}
object rightParen extends Token(")") {}


shared void run() {
	
	function shunt(String input) {
		
		function tokenize(String input) =>
				input.split().map((String element) =>
					switch(element.trimmed)
					case("(") leftParen
					case(")") rightParen
					case("+") Operator.plus
					case("-") Operator.minus
					case("*") Operator.times
					case("/") Operator.divides
					case("^") Operator.power
					else IntegerLiteral(parseInteger(element) else 0)); // no error handling
		
		value outputQueue = ArrayList<Token>();
		value operatorStack = ArrayList<Token>();
		
		void report(String action) {
			print("``action.padTrailing(22)`` | ``" ".join(outputQueue).padTrailing(25)`` | ``" ".join(operatorStack).padTrailing(10)``");
		}
		
		print("input is ``input``\n");
		print("Action                 | Output Queue              | Operators' Stack
		       -----------------------|---------------------------|-----------------");
		
		for(token in tokenize(input)) {
			switch(token)
			case(is IntegerLiteral) {
				outputQueue.offer(token);
				report("``token`` from input to queue");
			}
			case(leftParen) {
				operatorStack.push(token);
				report("``token`` from input to stack");
			}
			case(rightParen){
				while(exists top = operatorStack.pop(), top != leftParen) {
					outputQueue.offer(top);
					report("``top`` from stack to queue");
				}
			}
			case(is Operator) {
				while(exists top = operatorStack.top, is Operator top, token.below(top)) {
					operatorStack.pop();
					outputQueue.offer(top);
					report("``top`` from stack to queue");
				}
				operatorStack.push(token);
				report("``token`` from input to stack");
			}
		}
		while(exists top = operatorStack.pop()) {
			outputQueue.offer(top);
			report("``top`` from stack to queue");
		}
		return " ".join(outputQueue);
	}
	
	value rpn = shunt("3 + 4 * 2 / ( 1 - 5 ) ^ 2 ^ 3");
	assert(rpn == "3 4 2 * 1 5 - 2 3 ^ ^ / +");
	print("\nthe result is ``rpn``");
}
