import "./fmt" for Conv, Fmt

System.print("Numbers under 25,000 in base 10 which are palindromic in bases 2, 4 and 16:")
var numbers = []
for (i in 0..24999) {
    var b2 = Conv.itoa(i, 2)
    if (b2 == b2[-1..0]) {
        var b4 = Conv.itoa(i, 4)
        if (b4 == b4[-1..0]) {
            var b16 = Conv.itoa(i, 16)
            if (b16 == b16[-1..0]) numbers.add(i)
        }
    }
}
Fmt.tprint("$,6d", numbers, 8)
System.print("\nFound %(numbers.count) such numbers.")
