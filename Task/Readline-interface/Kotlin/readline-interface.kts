// version 1.0.6

var range   = intArrayOf()  // empty initially
val history = mutableListOf<String>()

fun greeting() {
    ProcessBuilder("cmd", "/c", "cls").inheritIO().start().waitFor()  // clears console in windows 10
    println("**     Welcome to the Ranger readline interface     **")
    println("** which performs operations on a range of integers **\n")
    println("Commands available:")
    println(" range [i] [j], help, show, square, cube, add [n], sub [n]")
    println(" mul [n], prev, hist, quit")
    println()
}

fun setRange(start: Int, end: Int) {
    range = IntArray(end - start + 1) { it + start }
    show()
}

fun help() {
    println(" range [i] [j] - sets the current range to [i, j] and shows them")
    println("               - if i > j, sets the current range to the single value [i]")
    println(" help          - displays help for each command")
    println(" show          - displays a maximum of 10 values from the current range")
    println(" square        - sets the current range to their squares and shows them")
    println(" cube          - sets the current range to their cubes and shows them")
    println(" add [i]       - adds [i] to the current range and shows them")
    println(" sub [i]       - subtracts [i] from the current range and shows them")
    println(" mul [i]       - multiplies the current range by [i] and shows them")
    println(" prev          - displays previous command entered")
    println(" hist          - displays a maximum of last 10 commands entered, newest first")
    println(" quit          - quits Ranger")
    println()
    println(" < items in square brackets denote integers to be supplied e.g. range 1 5 >")
    println(" < right/left arrow keys can be used to scroll through previous commands  >")
}

fun show() {
    val max = if (range.size > 10) 10 else range.size
    val more = range.size - max
    for (i in 0 until max) println("  ${range[i]}")
    if (more > 0) println("  plus $more more")
}

fun square() {
    for (i in 0 until range.size) range[i] *= range[i]
    show()
}

fun cube() {
    for (i in 0 until range.size) range[i] *= range[i] * range[i]
    show()
}

fun add(n: Int) {
    for (i in 0 until range.size) range[i] += n
    show()
}

fun sub(n: Int) {
    for (i in 0 until range.size) range[i] -= n
    show()
}

fun mul(n: Int) {
    for (i in 0 until range.size) range[i] *= n
    show()
}

fun prev() {
    if (history.size == 0) println("- No history yet") else println("- ${history.last()}")
}

fun showHistory() {
    val size = history.size
    if (size == 0) {println("- No history yet"); return}
    val max = if (size > 10) 10 else size
    val more = size - max
    for (i in size - 1 downTo size - max) println("- ${history[i]}")
    if (more > 0) println("- plus $more more")
}

fun main(args: Array<String>) {
    val r = Regex ("\\s+")
    val rangeCommands = arrayOf("show", "square", "cube", "add", "sub", "mul")
    greeting()
    while (true) {
        var command = readLine()!!.trim().toLowerCase()
        if (command == "") continue
        var i: Int = 0
        var j: Int = 0
        var addToHistory = true

        if (command.startsWith("range")) {
            if (command == "range") { println("- Parameters required, try again\n"); continue}
            val splits = command.split(r)
            if (splits.size == 3) {
               try {
                   i = splits[1].toInt()
                   j = splits[2].toInt()
                   if (i > j) j = i
                   command = "range"
                   history.add("$command $i $j")
                   addToHistory = false
               }
               catch(ex: NumberFormatException) {
               }
            }
        }
        else if (command.startsWith("add") || command.startsWith("sub") || command.startsWith("mul")) {
            if (command.length == 3) { println("- Parameter required, try again\n"); continue}
            val splits2 = command.split(r)
            if (splits2.size == 2) {
                try {
                   i = splits2[1].toInt()
                   command = command.take(3)
                   history.add("$command $i")
                   addToHistory = false
               }
               catch(ex: NumberFormatException) {
               }
            }
        }

        if (range.size == 0 && command in rangeCommands) {
            println("- Range has not yet been set\n")
            if (addToHistory) history.add(command)
            continue
        }

        when (command) {
            "range"  -> setRange(i, j)
            "help"   -> help()
            "show"   -> show()
            "square" -> square()
            "cube"   -> cube()
            "add"    -> add(i)
            "sub"    -> sub(i)
            "mul"    -> mul(i)
            "prev"   -> prev()
            "hist"   -> showHistory()
            "quit"   -> return
             else    -> {addToHistory = false; println("- Invalid command, try again")}
        }

        if (addToHistory) history.add(command)
        println()
    }
}
