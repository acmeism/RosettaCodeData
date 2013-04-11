def evaluateRPN(expression) {
    def stack = [] as Stack
    def binaryOp = { action -> return { action.call(stack.pop(), stack.pop()) } }
    def actions = [
        '+': binaryOp { a, b -> b + a },
        '-': binaryOp { a, b -> b - a },
        '*': binaryOp { a, b -> b * a },
        '/': binaryOp { a, b -> b / a },
        '^': binaryOp { a, b -> b ** a }
    ]
    expression.split(' ').each { item ->
        def action = actions[item] ?: { item as BigDecimal }
        stack.push(action.call())

        println "$item: $stack"
    }
    assert stack.size() == 1 : "Unbalanced Expression: $expression ($stack)"
    stack.pop()
}
