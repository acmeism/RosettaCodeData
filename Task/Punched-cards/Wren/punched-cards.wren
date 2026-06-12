var punchCard = Fn.new { |text|
    var card = List.filled(81, null)
    for (i in 0..80) card[i] = List.filled(13, false)

    var put = Fn.new { |j, prefix|
        System.write(prefix)
        for (i in 1..80) System.write(card[i][j] ? "x" : " ")
        System.print("|")
    }

    if (text.count > 80) Fiber.abort("Too many columns.")
    for (i in 0...text.count) {
        var punch = Fn.new { |j, k, l|
            card[i + 1][j] = true
            if (k) card[i + 1][k] = true
            if (l) card[i + 1][l] = true
        }
        var c = text[i]
        var b = c.bytes[0]
        if (c == "&") {
            punch.call(12, null, null)
        } else if (b >= 65 && b <= 73) { // A to I
            punch.call(12, b - 64, null)
        } else if (c == "[") {
            punch.call(2, 8, 12)
        } else if (c == ".") {
            punch.call(3, 8, 12)
        } else if (c == "<") {
            punch.call(4, 8, 12)
        } else if (c == "(") {
            punch.call(5, 8, 12)
        } else if (c == "+") {
            punch.call(6, 8, 12)
        } else if (c == "!") {
            punch.call(7, 8, 12)
        } else if (c == "-") {
            punch.call(11, null, null)
        } else if (b >= 74 && b <= 82) { // J to R
            punch.call(11, b - 73, null)
        } else if (c == "]") {
            punch.call(2, 8, 11)
        } else if (c == "$") {
            punch.call(3, 8, 11)
        } else if (c == "*") {
            punch.call(4, 8, 11)
        } else if (c == ")") {
            punch.call(5, 8, 11)
        } else if (c == ";") {
            punch.call(6, 8, 11)
        } else if (c == "^") {
            punch.call(7, 8, 11)
        } else if (c == "/") {
            punch.call(0, 1, null)
        } else if (b >= 83 && b <= 90) { // S to Z
            punch.call(0, b - 81, null)
        } else if (c == "\\") {
            punch.call(2, 8, 0)
        } else if (c == ",") {
            punch.call(3, 8, 0)
        } else if (c == "\%") {
            punch.call(4, 8, 0)
        } else if (c == "_") {
            punch.call(5, 8, 0)
        } else if (c == ">") {
            punch.call(6, 8, 0)
        } else if (c == "?") {
            punch.call(7, 8, 0)
        } else if (c == " ") {
            // no action
        } else if (b >= 48 && b <= 57) { // 0 to 9
            punch.call(b - 48, null, null)
        } else if (c == "`") {
            punch.call(1, 8, null)
        } else if (c == ":") {
            punch.call(2, 8, null)
        } else if (c == "#") {
            punch.call(3, 8, null)
        } else if (c == "@") {
            punch.call(4, 8, null)
        } else if (c == "'") {
            punch.call(5, 8, null)
        } else if (c == "=") {
            punch.call(6, 8, null)
        } else if (c == "\"") {
            punch.call(7, 8, null)
        } else if (b >= 97 && b <= 105) { // a to i
            punch.call(12, 0, b - 96)
        } else if (c == "|") {
            punch.call(12, 11, null)
        } else if (b >= 106 && b <= 114) { // j to r
            punch.call(12, 11, b - 105)
        } else if (b >= 115 && b <= 122) { // s to z
            punch.call(11, 0, b - 113)
        } else {
            Fiber.abort("Invalid code '%(c)'")
        }
    }
    System.print(" " + ("_" * 80) + ".")
    put.call(12, "/")
    put.call(11, "|")
    for (j in 0..9) put.call(j, "|")
    System.print("|" + ("_" * 80) + "|")
}

punchCard.call("&-0123456789ABCDEFGHIJKLMNOPQR/STUVWXYZ:#@'=\"[.<(+|]$*);^\\,\%_>?")
System.print("Hello World!")
punchCard.call("""System.print("Hello World!")""")
