import ceylon.random {
	DefaultRandom
}

shared sealed class Rational(numerator, denominator = 1) satisfies Numeric<Rational> {
	
	shared Integer numerator;
	shared Integer denominator;
	
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
		} else {
			return false;
		}
	}
}

shared Rational? rational(Integer numerator, Integer denominator = 1) =>
	if (denominator == 0)
	then null
	else Rational(numerator, denominator).simplified;

shared Rational numeratorOverOne(Integer numerator) => Rational(numerator);

shared abstract class Operation(String lexeme) of addition | subtraction | multiplication | division {
	shared formal Rational perform(Rational left, Rational right);
	string => lexeme;
}

shared object addition extends Operation("+") {
	perform(Rational left, Rational right) => left + right;
}
shared object subtraction extends Operation("-") {
	perform(Rational left, Rational right) => left - right;
}
shared object multiplication extends Operation("*") {
	perform(Rational left, Rational right) => left * right;
}
shared object division extends Operation("/") {
	perform(Rational left, Rational right) => left / right;
}

shared Operation[] operations = `Operation`.caseValues;

shared interface Expression of NumberExpression | OperationExpression {
	shared formal Rational evaluate();
}

shared class NumberExpression(Rational number) satisfies Expression {
	evaluate() => number;
	string => number.string;
}
shared class OperationExpression(Expression left, Operation op, Expression right) satisfies Expression {
	evaluate() => op.perform(left.evaluate(), right.evaluate());
	string => "(``left`` ``op`` ``right``)";
}

shared void run() {
	
	value twentyfour = numeratorOverOne(24);
	
	value random = DefaultRandom();
	
	function buildExpressions({Rational*} numbers, Operation* ops) {
		assert (is NumberExpression[4] numTuple = numbers.collect(NumberExpression).tuple());
		assert (is Operation[3] opTuple = ops.sequence().tuple());
		value [a, b, c, d] = numTuple;
		value [op1, op2, op3] = opTuple;
		value opExp = OperationExpression; // this is just to give it a shorter name
		return [
			opExp(opExp(opExp(a, op1, b), op2, c), op3, d),
			opExp(opExp(a, op1, opExp(b, op2, c)), op3, d),
			opExp(a, op1, opExp(opExp(b, op2, c), op3, d)),
			opExp(a, op1, opExp(b, op2, opExp(c, op3, d)))
		];
	}
	
	print("Please enter your 4 numbers to see how they form 24 or enter the letter r for random numbers.");
	
	if (exists line = process.readLine()) {
		
		Rational[] chosenNumbers;
		
		if (line.trimmed.uppercased == "R") {
			chosenNumbers = random.elements(1..9).take(4).collect((Integer element) => numeratorOverOne(element));
			print("The random numbers are ``chosenNumbers``");
		} else {
			chosenNumbers = line.split().map(Integer.parse).narrow<Integer>().collect(numeratorOverOne);
		}
		
		value expressions = {
			for (numbers in chosenNumbers.permutations)
			for (op1 in operations)
			for (op2 in operations)
			for (op3 in operations)
			for (exp in buildExpressions(numbers, op1, op2, op3))
			if (exp.evaluate() == twentyfour)
			exp
		};
		
		print("The solutions are:");
		expressions.each(print);
	}
}
