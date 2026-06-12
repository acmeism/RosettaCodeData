class ExpressionPrintingVisitor {
    construct new(){}

    printLiteral(literal) { System.print(literal.value) }

    printAddition(addition) {
        var leftValue   = addition.left.value
        var rightValue  = addition.right.value
        var sum = addition.value
        System.print("%(leftValue) + %(rightValue) = %(sum)")
    }
}

// abstract class
class Expression {
    accept(visitor) {}
    value {}
}

class Literal is Expression {
    construct new(value) {
        _value = value
    }

    value       { _value }
    value=(val) { _value = val }

    accept(visitor) {
        visitor.printLiteral(this)
    }
}

class Addition is Expression {
    construct new(left, right) {
        _left = left
        _right = right
    }

    left        { _left }
    left=(exp)  { _left = exp }

    right       { _right }
    right=(exp) { _right = exp }

    accept(visitor) {
        _left.accept(visitor)
        _right.accept(visitor)
        visitor.printAddition(this)
    }

    value { _left.value + _right.value }
}

// Emulate 1 + 2 + 3
var e = Addition.new(
    Addition.new(Literal.new(1), Literal.new(2)),
    Literal.new(3)
)
var printingVisitor = ExpressionPrintingVisitor.new()
e.accept(printingVisitor)
