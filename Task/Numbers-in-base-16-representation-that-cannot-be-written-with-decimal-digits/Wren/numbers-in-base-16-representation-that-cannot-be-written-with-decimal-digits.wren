import "./fmt" for Conv, Fmt

var decimal = "0123456789"
var c = 0
for (i in 1..499) {
    var hex = Conv.hex(i)
    if (!hex.any { |c| decimal.contains(c) }) {
        Fmt.write("$3s ", i)
        c = c + 1
        if (c % 14 == 0) System.print()
    }
}
System.print("\n%(c) such numbers found.")
