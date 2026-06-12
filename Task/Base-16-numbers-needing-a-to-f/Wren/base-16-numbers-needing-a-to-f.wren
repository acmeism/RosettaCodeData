import "./fmt" for Conv, Fmt

var nondecimal = "abcdef"
var c = 0
for (i in 0..500) {
    var hex = Conv.hex(i)
    if (hex.any { |c| nondecimal.contains(c) }) {
        Fmt.write("$3s ", i)
        c = c + 1
        if (c % 15 == 0) System.print()
    }
}
System.print("\n\n%(c) such numbers found.")
