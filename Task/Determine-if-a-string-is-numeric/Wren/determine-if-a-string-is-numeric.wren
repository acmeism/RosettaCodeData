import "./fmt" for Fmt

System.print("Are these strings numeric?")

for (s in ["1", "3.14", "-100", "1e2", "NaN", "0xaf", "rose"]) {
    var  i = Num.fromString(s) // returns null if 's' is not numeric
    System.print("  %(Fmt.s(4, s)) -> %((i != null) ? "yes" : "no")")
}
