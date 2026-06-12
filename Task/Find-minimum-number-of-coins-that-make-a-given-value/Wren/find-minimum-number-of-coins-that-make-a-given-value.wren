import "./fmt" for Fmt

var denoms = [200, 100, 50, 20, 10, 5, 2, 1]
var coins = 0
var amount = 988
var remaining = 988
System.print("The minimum number of coins needed to make a value of %(amount) is as follows:")
for (denom in denoms) {
    var n = (remaining / denom).floor
    if (n > 0) {
        coins = coins + n
        Fmt.print("  $3d x $d", denom, n)
        remaining = remaining  % denom
        if (remaining == 0) break
    }
}
System.print("\nA total of %(coins) coins in all.")
