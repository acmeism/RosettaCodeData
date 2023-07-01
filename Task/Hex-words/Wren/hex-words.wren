import "./ioutil" for FileUtil
import "./fmt" for Conv, Fmt
import "./math" for Int
import "./seq" for Lst

var words = FileUtil.readLines("unixdict.txt").where { |w| w.count > 0 && w[0].bytes[0] < 103 }
var hexDigits = "abcdef"
var lines = []
for (word in words) {
    if (word.count < 4) continue
    if (word.all { |c| hexDigits.contains(c) }) {
        var num = Conv.atoi(word, 16)
        var dr = Int.digitalRoot(num)[0]
        lines.add(Fmt.swrite("$-7s -> $-9s -> $d", word, num, dr))
    }
}
lines.sort { |a, b| a[-1].bytes[0] < b[-1].bytes[0] }
System.print(lines.join("\n"))
System.print("\n%(lines.count) hex words with 4 or more letters found.\n")
var digits4 = []
for (line in lines) {
    var word = line.split("->")[0].trimEnd()
    if (Lst.distinct(word.toList).count >= 4) digits4.add(line)
}
digits4.sort { |a, b| Num.fromString(a.split("->")[1]) > Num.fromString(b.split("->")[1]) }
System.print(digits4.join("\n"))
System.print("\n%(digits4.count) such words found which contain 4 or more different digits.")
