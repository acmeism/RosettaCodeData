enum Op {
    ADD('+', 2),
    SUBTRACT('-', 2),
    MULTIPLY('*', 1),
    DIVIDE('/', 1);

    static {
        ADD.operation = { a, b -> a + b }
        SUBTRACT.operation = { a, b -> a - b }
        MULTIPLY.operation = { a, b -> a * b }
        DIVIDE.operation = { a, b -> a / b }
    }

    final String symbol
    final int precedence
    Closure operation

    private Op(String symbol, int precedence) {
        this.symbol = symbol
        this.precedence = precedence
    }

    String toString() { symbol }

    static Op fromSymbol(String symbol) {
        Op.values().find { it.symbol == symbol }
    }
}

interface Expression {
    Number evaluate();
}

class Constant implements Expression {
    Number value

    Constant (Number value) { this.value = value }

    Constant (String str) {
        try { this.value = str as BigInteger }
        catch (e) { this.value = str as BigDecimal }
    }

    Number evaluate() { value }

    String toString() { "${value}" }
}

class Term implements Expression {
    Op op
    Expression left, right

    Number evaluate() { op.operation(left.evaluate(), right.evaluate()) }

    String toString() { "(${op} ${left} ${right})" }
}

void fail(String msg, Closure cond = {true}) {
    if (cond()) throw new IllegalArgumentException("Cannot parse expression: ${msg}")
}

Expression parse(String expr) {
    def tokens = tokenize(expr)
    def elements = groupByParens(tokens, 0)
    parse(elements)
}

List tokenize(String expr) {
    def tokens = []
    def constStr = ""
    def captureConstant = { i ->
        if (constStr) {
            try { tokens << new Constant(constStr) }
            catch (NumberFormatException e) { fail "Invalid constant '${constStr}' near position ${i}" }
            constStr = ''
        }
    }
    for(def i = 0; i<expr.size(); i++) {
        def c = expr[i]
        def constSign = c in ['+','-'] && constStr.empty && (tokens.empty || tokens[-1] != ')')
        def isConstChar = { it in ['.'] + ('0'..'9') || constSign }
        if (c in ([')'] + Op.values()*.symbol) && !constSign) { captureConstant(i) }
        switch (c) {
            case ~/\s/:               break
            case isConstChar:         constStr += c; break
            case Op.values()*.symbol: tokens << Op.fromSymbol(c); break
            case ['(',')']:           tokens << c; break
            default:                  fail "Invalid character '${c}' at position ${i+1}"
        }
    }
    captureConstant(expr.size())
    tokens
}

List groupByParens(List tokens, int depth) {
    def deepness = depth
    def tokenGroups = []
    for (def i = 0; i < tokens.size(); i++) {
        def token = tokens[i]
        switch (token) {
            case '(':
                fail("'(' too close to end of expression") { i+2 > tokens.size() }
                def subGroup = groupByParens(tokens[i+1..-1], depth+1)
                tokenGroups << subGroup[0..-2]
                i += subGroup[-1] + 1
                break
            case ')':
                fail("Unbalanced parens, found extra ')'") { deepness == 0 }
                tokenGroups << i
                return tokenGroups
            default:
                tokenGroups << token
        }
    }
    fail("Unbalanced parens, unclosed groupings at end of expression") { deepness != 0 }
    def n = tokenGroups.size()
    fail("The operand/operator sequence is wrong") { n%2 == 0 }
    (0..<n).each {
        def i = it
        fail("The operand/operator sequence is wrong") { (i%2 == 0) == (tokenGroups[i] instanceof Op) }
    }
    tokenGroups
}

Expression parse(List elements) {
    while (elements.size() > 1) {
        def n = elements.size()
        fail ("The operand/operator sequence is wrong") { n%2 == 0 }
        def groupLoc = (0..<n).find { i -> elements[i] instanceof List }
        if (groupLoc != null) {
            elements[groupLoc] = parse(elements[groupLoc])
            continue
        }
        def opLoc = (0..<n).find { i -> elements[i] instanceof Op && elements[i].precedence == 1 } \
                        ?: (0..<n).find { i -> elements[i] instanceof Op && elements[i].precedence == 2 }
        if (opLoc != null) {
            fail ("Operator out of sequence") { opLoc%2 == 0 }
            def term = new Term(left:elements[opLoc-1], op:elements[opLoc], right:elements[opLoc+1])
            elements[(opLoc-1)..(opLoc+1)] = [term]
            continue
        }
    }
    return elements[0] instanceof List ? parse(elements[0]) : elements[0]
}
