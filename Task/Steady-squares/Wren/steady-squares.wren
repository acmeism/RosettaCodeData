import "./fmt" for Fmt

System.print("Steady squares under 10,000:")
var finalDigits = [1, 5, 6]
for (i in 1..9999) {
    if (!finalDigits.contains(i % 10)) continue
    var sq = i * i
    if (sq.toString.endsWith(i.toString)) Fmt.print("$,5d -> $,10d", i, sq)
}
