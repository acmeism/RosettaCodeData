import "random" for Random

var isBalanced = Fn.new { |s|
    if (s.isEmpty) return true
    var countLeft = 0 // number of left brackets so far unmatched
    for (c in s) {
        if (c == "[") {
            countLeft = countLeft + 1
        } else if (countLeft > 0) {
            countLeft = countLeft - 1
        } else {
            return false
        }
    }
    return countLeft == 0
}

System.print("Checking examples in task description:")
var brackets = ["", "[]", "][", "[][]", "][][", "[[][]]", "[]][[]"]
for (b in brackets) {
    System.write((b != "") ? b : "(empty)")
    System.print("\t  %(isBalanced.call(b) ? "OK" : "NOT OK")")
}
System.print("\nChecking 7 random strings of brackets of length 8:")
var rand = Random.new()
for (i in 1..7) {
    var s = ""
    for (j in 1..8) s = s + ((rand.int(2) == 0) ? "[" : "]")
    System.print("%(s)  %(isBalanced.call(s) ? "OK" : "NOT OK")")
}
