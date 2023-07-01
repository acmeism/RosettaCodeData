// Version 1.3.21

fun showTokens(tokens: Int) {
    println("Tokens remaining $tokens\n")
}

fun main() {
    var tokens = 12
    while (true) {
        showTokens(tokens)
        print("  How many tokens 1, 2 or 3? ")
        var t = readLine()!!.toIntOrNull()
        if (t == null || t < 1 || t > 3) {
            println("\nMust be a number between 1 and 3, try again.\n")
        } else {
            var ct = 4 - t
            var s = if (ct > 1) "s" else ""
            println("  Computer takes $ct token$s\n")
            tokens -= 4
        }
        if (tokens == 0) {
            showTokens(0)
            println("  Computer wins!")
            return
        }
    }
}
