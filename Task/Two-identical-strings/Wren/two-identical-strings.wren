import "./fmt" for Conv, Fmt

var i = 1
while(true) {
    var b2 = Conv.itoa(i, 2)
    b2 = b2 + b2
    var d = Conv.atoi(b2, 2)
    if (d >= 1000) break
    Fmt.print("$3d : $s", d, b2)
    i = i + 1
}
System.print("\nFound %(i-1) numbers.")
