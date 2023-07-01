import ceylon.random {
	DefaultRandom
}

class Rational(shared Integer numerator, shared Integer denominator = 1) satisfies Numeric<Rational> {
	
	assert (denominator != 0);
	
	Integer gcd(Integer a, Integer b) => if (b == 0) then a else gcd(b, a % b);
	
	shared Rational inverted => Rational(denominator, numerator);
	
	shared Rational simplified =>
		let (largestFactor = gcd(numerator, denominator))
			Rational(numerator / largestFactor, denominator / largestFactor);
	
	divided(Rational other) => (this * other.inverted).simplified;
	
	negated => Rational(-numerator, denominator).simplified;
	
	plus(Rational other) =>
			let (top = numerator*other.denominator + other.numerator*denominator,
				bottom = denominator * other.denominator)
			Rational(top, bottom).simplified;
	
	times(Rational other) =>
		Rational(numerator * other.numerator, denominator * other.denominator).simplified;
	
	shared Integer integer => numerator / denominator;
	shared Float float => numerator.float / denominator.float;
	
	string => denominator == 1 then numerator.string else "``numerator``/``denominator``";
	
	shared actual Boolean equals(Object that) {
		if (is Rational that) {
			value simplifiedThis = this.simplified;
			value simplifiedThat = that.simplified;
			return simplifiedThis.numerator==simplifiedThat.numerator &&
					simplifiedThis.denominator==simplifiedThat.denominator;
		}
		else {
			return false;
		}
	}
}

interface Expression {
	shared formal Rational evaluate();
}

class NumberExpression(Rational number) satisfies Expression {
	evaluate() => number;
	string => number.string;
}

class OperatorExpression(Expression left, Character operator, Expression right) satisfies Expression {
	shared actual Rational evaluate() {
		switch (operator)
		case ('*') {
			return left.evaluate() * right.evaluate();
		}
		case ('/') {
			return left.evaluate() / right.evaluate();
		}
		case ('-') {
			return left.evaluate() - right.evaluate();
		}
		case ('+') {
			return left.evaluate() + right.evaluate();
		}
		else {
			throw Exception("unknown operator ``operator``");
		}
	}
	
	string => "(``left.string`` ``operator.string`` ``right.string``)";
}

"A simplified top down operator precedence parser. There aren't any right
 binding operators so we don't have to worry about that."
class PrattParser(String input) {
	
	value tokens = input.replace(" ", "");
	variable value index = -1;
	
	shared Expression expression(Integer precedence = 0) {
		value token = advance();
		variable value left = parseUnary(token);
		while (precedence < getPrecedence(peek())) {
			value nextToken = advance();
			left = parseBinary(left, nextToken);
		}
		return left;
	}
	
	Integer getPrecedence(Character op) =>
		switch (op)
			case ('*' | '/') 2
			case ('+' | '-') 1
			else 0;
	
	Character advance(Character? expected = null) {
		index++;
		value token = tokens[index] else ' ';
		if (exists expected, token != expected) {
			throw Exception("unknown character ``token``");
		}
		return token;
	}
	
	Character peek() => tokens[index + 1] else ' ';
	
	Expression parseBinary(Expression left, Character operator) =>
		let (right = expression(getPrecedence(operator)))
			OperatorExpression(left, operator, right);
	
	Expression parseUnary(Character token) {
		if (token.digit) {
			assert (is Integer int = Integer.parse(token.string));
			return NumberExpression(Rational(int));
		}
		else if (token == '(') {
			value exp = expression();
			advance(')');
			return exp;
		}
		else {
			throw Exception("unknown character ``token``");
		}
	}
}

shared void run() {
	
	value random = DefaultRandom();
	
	function random4Numbers() =>
		random.elements(1..9).take(4).sequence();
	
	function isValidGuess(String input, {Integer*} allowedNumbers) {
		value allowedOperators = set { *"()+-/*" };
		value extractedNumbers = input
			.split((Character ch) => ch in allowedOperators || ch.whitespace)
			.map((String element) => Integer.parse(element))
			.narrow<Integer>();
		if (extractedNumbers.any((Integer element) => element > 9)) {
			print("number too big!");
			return false;
		}
		if (extractedNumbers.any((Integer element) => element < 1)) {
			print("number too small!");
			return false;
		}
		if (extractedNumbers.sort(increasing) != allowedNumbers.sort(increasing)) {
			print("use all the numbers, please!");
			return false;
		}
		if (!input.every((Character element) => element in allowedOperators || element.digit || element.whitespace)) {
			print("only digits and mathematical operators, please");
			return false;
		}
		variable value leftParens = 0;
		for (c in input) {
			if (c == '(') {
				leftParens++;
			} else if (c == ')') {
				leftParens--;
				if (leftParens < 0) {
					break;
				}
			}
		}
		if (leftParens != 0) {
			print("unbalanced brackets!");
			return false;
		}
		return true;
	}
	
	function evaluate(String input) =>
		let (parser = PrattParser(input),
			exp = parser.expression())
			exp.evaluate();
	
	print("Welcome to The 24 Game.
	          Create a mathematical equation with four random
	          numbers that evaluates to 24.
	          You must use all the numbers once and only once,
	          but in any order.
	          Also, only + - / * and parentheses are allowed.
	          For example: (1 + 2 + 3) * 4
	          Also: enter n for new numbers and q to quit.
	          -----------------------------------------------");
	
	value twentyfour = Rational(24);
	
	while (true) {
		
		value chosenNumbers = random4Numbers();
		void pleaseTryAgain() => print("Sorry, please try again. (Your numbers are ``chosenNumbers``)");
		
		print("Your numbers are ``chosenNumbers``. Please turn them into 24.");
		
		while (true) {
			value line = process.readLine()?.trimmed;
			if (exists line) {
				if (line.uppercased == "Q") { // quit
					print("bye!");
					return;
				}
				if (line.uppercased == "N") { // new game
					break;
				}
				if (isValidGuess(line, chosenNumbers)) {
					try {
						value result = evaluate(line);
						print("= ``result``");
						if (result == twentyfour) {
							print("You did it!");
							break;
						}
						else {
							pleaseTryAgain();
						}
					}
					catch (Exception e) {
						print(e.message);
						pleaseTryAgain();
					}
				}
				else {
					pleaseTryAgain();
				}
			}
		}
	}
}
