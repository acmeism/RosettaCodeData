import "io" for File
import "/pattern" for Pattern
import "/fmt" for Fmt

var yesNo = Fn.new { |b| (b) ? "yes" : "no" }

var plausRatio = 2

var count1 = 0  // [^c]ie
var count2 = 0  // [^c]ei
var count3 = 0  // cie
var count4 = 0  // cei
var count5 = 0  // ^ie
var count6 = 0  // ^ei

var p0 = Pattern.new("+1/s")
var p1 = Pattern.new("^cie")
var p2 = Pattern.new("^cei")

var entries = File.read("corpus.txt").split("\n").map { |w| w.trim() }.where { |w| w != "" }
System.print("The following words fall into more than one category")
System.print("and so are counted more than their frequency:")
for (entry in entries.skip(1)) {
    var items = p0.splitAll(entry)
    if (items.count == 3) {
        var word = items[0]  // leave any trailing * in place
        var freq = Num.fromString(items[2])
        var tc1 = count1 + count2 + count3 + count4 + count5 + count6
        if (p1.isMatch(word)) count1 = count1 + freq
        if (p2.isMatch(word)) count2 = count2 + freq
        if (word.contains("cie")) count3 = count3 + freq
        if (word.contains("cei")) count4 = count4 + freq
        if (word.startsWith("ie")) count5 = count5 + freq
        if (word.startsWith("ei")) count6 = count6 + freq
        var tc2 = count1 + count2 + count3 + count4 + count5 + count6
        if ((tc2 -tc1) > freq) System.print("  " + word)
    }
}

System.print("\nChecking plausability of \"i before e except after c\":")
var nFor  = count1 + count5
var nAgst = count2 + count6
var ratio = nFor / nAgst
var plaus = (ratio > plausRatio)
Fmt.print("  Cases for      : $d", nFor)
Fmt.print("  Cases against  : $d", nAgst)
Fmt.print("  Ratio for/agst : $4.2f", ratio)
Fmt.print("  Plausible      : $s", yesNo.call(plaus))

System.print("\nChecking plausability of \"e before i when preceded by c\":")
var ratio2 = count4 / count3
var plaus2 = (ratio2 > plausRatio)
Fmt.print("  Cases for      : $d", count4)
Fmt.print("  Cases against  : $d", count3)
Fmt.print("  Ratio for/agst : $4.2f", ratio2)
Fmt.print("  Plausible      : $s", yesNo.call(plaus2))

Fmt.print("\nPlausible overall: $s", yesNo.call(plaus && plaus2))
