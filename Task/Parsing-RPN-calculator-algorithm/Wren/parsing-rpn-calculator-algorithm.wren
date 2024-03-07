import "./seq" for Stack

var rpnCalculate = Fn.new { |expr|
    if (expr == "") Fiber.abort("Expression cannot be empty.")
    System.print("For expression = %(expr)\n")
    System.print("Token           Action             Stack")
    var tokens = expr.split(" ").where { |t| t != "" }
    var stack = Stack.new()
    for (token in tokens) {
        var d = Num.fromString(token)
        if (d) {
            stack.push(d)
            System.print(" %(d)     Push num onto top of stack  %(stack)")
        } else if ((token.count > 1) || !"+-*/^".contains(token)) {
            Fiber.abort("%(token) is not a valid token.")
        } else if (stack.count < 2) {
            Fiber.abort("Stack contains too few operands.")
        } else {
            var d1 = stack.pop()
            var d2 = stack.pop()
            stack.push(token == "+" ? d2 + d1 :
                       token == "-" ? d2 - d1 :
                       token == "*" ? d2 * d1 :
                       token == "/" ? d2 / d1 : d2.pow(d1))
            System.print(" %(token)     Apply op to top of stack    %(stack)")
        }
    }
    System.print("\nThe final value is %(stack.pop())")
}

var expr = "3 4 2 * 1 5 - 2 3 ^ ^ / +"
rpnCalculate.call(expr)
