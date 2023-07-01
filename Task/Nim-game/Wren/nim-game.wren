import "io" for Stdin, Stdout

var showTokens = Fn.new { |tokens| System.print("Tokens remaining %(tokens)\n") }

var tokens = 12
while (true) {
    showTokens.call(tokens)
    System.write("  How many tokens 1, 2 or 3? ")
    Stdout.flush()
    var t = Num.fromString(Stdin.readLine())
    if (t.type != Num || !t.isInteger || t < 1 || t > 3) {
        System.print("\nMust be an integer between 1 and 3, try again.\n")
    } else {
        var ct = 4 - t
        var s = (ct != 1) ? "s" : ""
        System.write("  Computer takes %(ct) token%(s)\n\n")
        tokens = tokens - 4
    }
    if (tokens == 0) {
        showTokens.call(0)
        System.print("  Computer wins!")
        break
    }
}
