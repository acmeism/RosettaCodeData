import "/dynamic" for Struct
import "/ioutil" for Input
import "/seq" for Stack
import "/str" for Str

var Variable = Struct.create("Variable", ["name", "value"])

// use integer constants as bools don't support bitwise operators
var FALSE = 0
var TRUE = 1

var expr = ""
var variables = []

var isOperator = Fn.new { |op| "&|!^".contains(op) }

var isVariable = Fn.new { |s| variables.map { |v| v.name }.contains(s) }

var evalExpression = Fn.new {
    var stack = Stack.new()
    for (e in expr) {
        var v
        if (e == "T") {
            v = TRUE
        } else if (e == "F") {
            v = FALSE
        } else if (isVariable.call(e)) {
            var vs = variables.where { |v| v.name == e }.toList
            if (vs.count != 1) Fiber.abort("Can only be one variable with name %(e).")
            v = vs[0].value
        } else if (e == "&") {
            v = stack.pop() & stack.pop()
        } else if (e == "|") {
            v = stack.pop() | stack.pop()
        } else if (e == "!") {
            v = (stack.pop() == TRUE) ? FALSE : TRUE
        } else if (e == "^") {
            v = stack.pop() ^ stack.pop()
        } else {
            Fiber.abort("Non-conformant character %(e) in expression")
        }
        stack.push(v)
    }
    if (stack.count != 1) Fiber.abort("Something went wrong!")
    return stack.peek()
}

var setVariables // recursive
setVariables = Fn.new { |pos|
    var vc = variables.count
    if (pos > vc) Fiber.abort("Argument cannot exceed %(vc).")
    if (pos == vc) {
        var vs = variables.map { |v| (v.value == TRUE) ? "T" : "F" }.toList
        var es = (evalExpression.call() == TRUE) ? "T" : "F"
        System.print("%(vs.join("  "))  %(es)")
        return
    }
    variables[pos].value = FALSE
    setVariables.call(pos + 1)
    variables[pos].value = TRUE
    setVariables.call(pos + 1)
}

System.print("Accepts single-character variables (except for 'T' and 'F',")
System.print("which specify explicit true or false values), postfix, with")
System.print("&|!^ for and, or, not, xor, respectively; optionally")
System.print("seperated by spaces or tabs. Just enter nothing to quit.")

while (true) {
    expr = Input.text("\nBoolean expression: ")
    if (expr == "") return
    expr = Str.upper(expr).replace(" ", "").replace("\t", "")
    variables.clear()
    for (e in expr) {
        if (!isOperator.call(e) && !"TF".contains(e) && !isVariable.call(e)) {
            variables.add(Variable.new(e, FALSE))
        }
    }
    if (variables.isEmpty) return
    var vs = variables.map { |v| v.name }.join("  ")
    System.print("\n%(vs)  %(expr)")
    var h = vs.count + expr.count + 2
    System.print("=" * h)
    setVariables.call(0)
}
