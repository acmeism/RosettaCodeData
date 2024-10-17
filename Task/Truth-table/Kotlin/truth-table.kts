// Version 1.2.31

import java.util.Stack

class Variable(val name: Char, var value: Boolean = false)

lateinit var expr: String
var variables = mutableListOf<Variable>()

fun Char.isOperator() = this in "&|!^"

fun Char.isVariable() = this in variables.map { it.name }

fun evalExpression(): Boolean {
    val stack = Stack<Boolean>()

    for (e in expr) {
        stack.push(
            if (e == 'T')
                true
            else if (e == 'F')
                false
            else if (e.isVariable())
                variables.single { it.name == e }.value
            else when (e) {
                '&'   -> stack.pop() and stack.pop()
                '|'   -> stack.pop() or  stack.pop()
                '!'   -> !stack.pop()
                '^'   -> stack.pop() xor stack.pop()
                else  -> throw RuntimeException("Non-conformant character '$e' in expression")
            }
        )
    }

    require(stack.size == 1)
    return stack.peek()
}

fun setVariables(pos: Int) {
    require(pos <= variables.size)
    if (pos == variables.size) {
        val vs = variables.map { if (it.value) "T" else "F" }.joinToString("  ")
        val es = if (evalExpression()) "T" else "F"
        return println("$vs  $es")
    }
    variables[pos].value = false
    setVariables(pos + 1)
    variables[pos].value = true
    setVariables(pos + 1)
}

fun main(args: Array<String>) {
    println("Accepts single-character variables (except for 'T' and 'F',")
    println("which specify explicit true or false values), postfix, with")
    println("&|!^ for and, or, not, xor, respectively; optionally")
    println("seperated by spaces or tabs. Just enter nothing to quit.")

    while (true) {
        print("\nBoolean expression: ")
        expr = readLine()!!.toUpperCase().replace(" ", "").replace("\t", "")
        if (expr == "") return
        variables.clear()
        for (e in expr) {
            if (!e.isOperator() && e !in "TF" && !e.isVariable()) variables.add(Variable(e))
        }
        if (variables.isEmpty()) return
        val vs = variables.map { it.name }.joinToString("  ")
        println("\n$vs  $expr")
        val h = vs.length + expr.length + 2
        repeat(h) { print("=") }
        println("\n")
        setVariables(0)
    }
}
