package main

import "fmt"

func main() {
    amount := 100
    fmt.Println("amount, ways to make change:", amount, countChange(amount))
}

func countChange(amount int) int64 {
    return cc(amount, 4)
}

func cc(amount, kindsOfCoins int) int64 {
    switch {
    case amount == 0:
        return 1
    case amount < 0 || kindsOfCoins == 0:
        return 0
    }
    return cc(amount, kindsOfCoins-1) +
        cc(amount - firstDenomination(kindsOfCoins), kindsOfCoins)
}

func firstDenomination(kindsOfCoins int) int {
    switch kindsOfCoins {
    case 1:
        return 1
    case 2:
        return 5
    case 3:
        return 10
    case 4:
        return 25
    }
    panic(kindsOfCoins)
}
