import "./ioutil" for Input, FileUtil
import "./str" for Str

var areAbcCountsEqual = Fn.new { |s, checkCase|
    var a = 0
    var b = 0
    var c = 0
    if (checkCase) s = Str.lower(s)
    for (ch in s) {
        if (ch == "a") {
            a = a + 1
        } else if (ch == "b") {
            b = b + 1
        } else if (ch == "c") {
            c = c + 1
        }
    }
    return a == b && b == c
}

while (true) {
    var s = Input.text("Enter a string or 'q' to quit: ", 1)
    if (s == "q") break
    var res = areAbcCountsEqual.call(s, true)
    System.print("The counts of 'a', 'b', 'c' are %(res ? "equal" : "not equal").\n")
}

var words = FileUtil.readLines("unixdict.txt") // local copy
var c = words.count { |w| w.contains("a") && areAbcCountsEqual.call(w, false) }
System.print("\nThere are %(c) words in unixdict.txt which have at least one 'a' and equal numbers of 'a', 'b' and 'c'.")

words = FileUtil.readLines("words_alpha.txt") // local copy
var eligible = words.where { |w|
    var a = Str.occurs(w, "a")
    if (a < 2) return false
    var b = Str.occurs(w, "b")
    if (a != b) return false
    return b == Str.occurs(w, "c")
}
System.print("\nWords in words_alpha.txt which contain equal numbers of 'a', 'b' and 'c' and at least two of each of them (%(eligible.count) such words found):")
System.print(eligible.join("\n"))
