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

var p1 = Pattern.new("^cie")
var p2 = Pattern.new("^cei")

var words = File.read("unixdict.txt").split("\n").map { |w| w.trim() }.where { |w| w != "" }
System.print("The following words fall into more than one category")
System.print("and so are counted more than once:")
for (word in words) {
    var tc1 = count1 + count2 + count3 + count4 + count5 + count6
    if (p1.isMatch(word)) count1 = count1 + 1
    if (p2.isMatch(word)) count2 = count2 + 1
    if (word.contains("cie")) count3 = count3 + 1
    if (word.contains("cei")) count4 = count4 + 1
    if (word.startsWith("ie")) count5 = count5 + 1
    if (word.startsWith("ei")) count6 = count6 + 1
    var tc2 = count1 + count2 + count3 + count4 + count5 + count6
    if ((tc2 -tc1) > 1) System.print("  " + word)
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
