package main

import (
    "fmt"
    "math/big"
)

func main() {
    var a, b, c big.Int
    fmt.Print("enter two integers: ")
    fmt.Scan(&a, &b)
    fmt.Printf("%d + %d = %d\n", &a, &b, c.Add(&a, &b))
    fmt.Printf("%d - %d = %d\n", &a, &b, c.Sub(&a, &b))
    fmt.Printf("%d * %d = %d\n", &a, &b, c.Mul(&a, &b))

    // Quo, Rem functions work like Go operators on int:
    // quo truncates toward 0,
    // and a non-zero rem has the same sign as the first operand.
    fmt.Printf("%d quo %d = %d\n", &a, &b, c.Quo(&a, &b))
    fmt.Printf("%d rem %d = %d\n", &a, &b, c.Rem(&a, &b))

    // Div, Mod functions do Euclidean division:
    // the result m = a mod b is always non-negative,
    // and for d = a div b, the results d and m give d*y + m = x.
    fmt.Printf("%d div %d = %d\n", &a, &b, c.Div(&a, &b))
    fmt.Printf("%d mod %d = %d\n", &a, &b, c.Mod(&a, &b))

    // as with int, no exponentiation operator
}
