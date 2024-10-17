// version 1.2.10

enum class Dir { LEFT, RIGHT, STAY }

class Rule(
    val state1: String,
    val symbol1: Char,
    val symbol2: Char,
    val dir: Dir,
    val state2: String
)

class Tape(
    var symbol: Char,
    var left: Tape? = null,
    var right: Tape? = null
)

class Turing(
    val states: List<String>,
    val finalStates: List<String>,
    val symbols: CharArray,
    val blank: Char,
    var state: String,
    tapeInput: CharArray,
    rules: List<Rule>
) {
    var tape: Tape? = null
    val transitions = Array(states.size) { arrayOfNulls<Rule>(symbols.size) }

    init {
        for (i in 0 until tapeInput.size) {
            move(Dir.RIGHT)
            tape!!.symbol = tapeInput[i]
        }
        if (tapeInput.size == 0) move(Dir.RIGHT)
        while (tape!!.left != null) tape = tape!!.left
        for (i in 0 until rules.size) {
            val rule = rules[i]
            transitions[stateIndex(rule.state1)][symbolIndex(rule.symbol1)] = rule
        }
    }

    private fun stateIndex(state: String): Int {
        val i = states.indexOf(state)
        return if (i >= 0) i else 0
    }

    private fun symbolIndex(symbol: Char): Int {
        val i = symbols.indexOf(symbol)
        return if (i >= 0) i else 0
    }

    private fun move(dir: Dir) {
        val orig = tape
        when (dir) {
            Dir.RIGHT -> {
                if (orig != null && orig.right != null) {
                    tape = orig.right
                }
                else {
                    tape = Tape(blank)
                    if (orig != null) {
                        tape!!.left = orig
                        orig.right = tape
                    }
                }
            }

            Dir.LEFT -> {
                if (orig != null && orig.left != null) {
                    tape = orig.left
                }
                else {
                    tape = Tape(blank)
                    if (orig != null) {
                        tape!!.right = orig
                        orig.left = tape
                    }
                }
            }

            Dir.STAY -> {}
        }
    }

    fun printState() {
        print("%-10s ".format(state))
        var t = tape
        while (t!!.left != null ) t = t.left
        while (t != null) {
            if (t == tape) print("[${t.symbol}]")
            else           print(" ${t.symbol} ")
            t = t.right
        }
        println()
    }

    fun run(maxLines: Int = 20) {
        var lines = 0
        while (true) {
            printState()
            for (finalState in finalStates) {
                if (finalState == state) return
            }
            if (++lines == maxLines) {
                println("(Only the first $maxLines lines displayed)")
                return
            }
            val rule = transitions[stateIndex(state)][symbolIndex(tape!!.symbol)]
            tape!!.symbol = rule!!.symbol2
            move(rule.dir)
            state = rule.state2
        }
    }
}

fun main(args: Array<String>) {
    println("Simple incrementer")
    Turing(
        states      = listOf("q0", "qf"),
        finalStates = listOf("qf"),
        symbols     = charArrayOf('B', '1'),
        blank       = 'B',
        state       = "q0",
        tapeInput   = charArrayOf('1', '1', '1'),
        rules       = listOf(
            Rule("q0", '1', '1', Dir.RIGHT, "q0"),
            Rule("q0", 'B', '1', Dir.STAY, "qf")
        )
    ).run()

    println("\nThree-state busy beaver")
    Turing(
        states      = listOf("a", "b", "c", "halt"),
        finalStates = listOf("halt"),
        symbols     = charArrayOf('0', '1'),
        blank       = '0',
        state       = "a",
        tapeInput   = charArrayOf(),
        rules       = listOf(
            Rule("a", '0', '1', Dir.RIGHT, "b"),
            Rule("a", '1', '1', Dir.LEFT, "c"),
            Rule("b", '0', '1', Dir.LEFT, "a"),
            Rule("b", '1', '1', Dir.RIGHT, "b"),
            Rule("c", '0', '1', Dir.LEFT, "b"),
            Rule("c", '1', '1', Dir.STAY, "halt")
        )
    ).run()

    println("\nFive-state two-symbol probable busy beaver")
    Turing(
        states      = listOf("A", "B", "C", "D", "E", "H"),
        finalStates = listOf("H"),
        symbols     = charArrayOf('0', '1'),
        blank       = '0',
        state       = "A",
        tapeInput   = charArrayOf(),
        rules       = listOf(
            Rule("A", '0', '1', Dir.RIGHT, "B"),
            Rule("A", '1', '1', Dir.LEFT, "C"),
            Rule("B", '0', '1', Dir.RIGHT, "C"),
            Rule("B", '1', '1', Dir.RIGHT, "B"),
            Rule("C", '0', '1', Dir.RIGHT, "D"),
            Rule("C", '1', '0', Dir.LEFT, "E"),
            Rule("D", '0', '1', Dir.LEFT, "A"),
            Rule("D", '1', '1', Dir.LEFT, "D"),
            Rule("E", '0', '1', Dir.STAY, "H"),
            Rule("E", '1', '0', Dir.LEFT, "A")
        )
    ).run()
}
