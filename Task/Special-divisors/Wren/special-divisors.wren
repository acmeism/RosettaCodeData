import "./math" for Int
import "./fmt" for Fmt

var reversed = Fn.new { |n|
    var rev = 0
    while (n > 0) {
        rev = rev * 10 + n % 10
        n = (n/10).floor
    }
    return rev
}

var special = []
for (n in 1...200) {
    var divs = Int.divisors(n)
    var revN = reversed.call(n)
    if (divs.all { |d| revN % reversed.call(d) == 0 }) special.add(n)
}
System.print("Special divisors in the range 0..199:")
Fmt.tprint("$3d", special, 12)
System.print("\n%(special.count) special divisors found.")
