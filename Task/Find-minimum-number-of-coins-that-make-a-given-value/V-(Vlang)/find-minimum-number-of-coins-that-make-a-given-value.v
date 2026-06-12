fn main() {
    denoms := [200, 100, 50, 20, 10, 5, 2, 1]
	amount := 988
    mut coins, mut n, mut remaining := 0, 0, 988
    println("The minimum number of coins needed to make a value of ${amount} is as follows:")
    for denom in denoms {
		n = remaining / denom
        if n > 0 {
            coins += n
            print("  ${denom} x ${n}" + "\n")
            remaining %= denom
            if remaining == 0 {break}
        }
    }
    println("\nA total of ${coins} coins in all.")
}
