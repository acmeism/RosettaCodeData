package main

import (
    "fmt"
    "github.com/ALTree/bigfloat"
    "math/big"
    "rcu"
)

func main() {
    t := make([]int, 30)
    for n := 1; n < 30; n++ {
        t[n] = t[n-1] + n
    }
    fmt.Println("The first 30 triangular numbers are:")
    rcu.PrintTable(t, 6, 3, false)

    for n := 1; n < 30; n++ {
        t[n] += t[n-1]
    }
    fmt.Println("\nThe first 30 tetrahedral numbers are:")
    rcu.PrintTable(t, 6, 4, false)

    for n := 1; n < 30; n++ {
        t[n] += t[n-1]
    }
    fmt.Println("\nThe first 30 pentatopic numbers are:")
    rcu.PrintTable(t, 6, 5, false)

    for r := 5; r <= 12; r++ {
        for n := 1; n < 30; n++ {
            t[n] += t[n-1]
        }
    }
    fmt.Println("\nThe first 30 12-simplex numbers are:")
    rcu.PrintTable(t, 6, 10, false)

    const prec = 256
    xs := []float64{7140, 21408696, 26728085384, 14545501785001}
    root := new(big.Float)
    temp := new(big.Float)
    temp2 := new(big.Float)
    one := big.NewFloat(1)
    two := big.NewFloat(2)
    three := big.NewFloat(3)
    four := big.NewFloat(4)
    five := big.NewFloat(5)
    eight := big.NewFloat(8)
    nine := big.NewFloat(9)
    twentyFour := big.NewFloat(24)
    twentySeven := big.NewFloat(27)
    third := new(big.Float).SetPrec(prec).Quo(one, three)
    for _, x := range xs {
        bx := big.NewFloat(x).SetPrec(prec)
        fmt.Printf("\nRoots of %d:\n", int(x))
        root.Mul(bx, eight)
        root.Add(root, one)
        root.Sqrt(root)
        root.Sub(root, one)
        root.Quo(root, two)
        fmt.Printf("%14s: %.24f\n", "triangular", root)

        temp.Mul(bx, bx)
        temp.Mul(temp, nine)
        temp.Sub(temp, new(big.Float).SetPrec(prec).Quo(one, twentySeven))
        temp.Sqrt(temp)
        temp2.Mul(bx, three)
        temp2.Sub(temp2, temp)
        temp2 = bigfloat.Pow(temp2, third)
        root.Mul(bx, three)
        root.Add(root, temp)
        root = bigfloat.Pow(root, third)
        root.Add(root, temp2)
        root.Sub(root, one)
        fmt.Printf("%14s: %.24f\n", "tetrahedral", root)

        root.Mul(bx, twentyFour)
        root.Add(root, one)
        root.Sqrt(root)
        root.Mul(root, four)
        root.Add(root, five)
        root.Sqrt(root)
        root.Sub(root, three)
        root.Quo(root, two)
        fmt.Printf("%14s: %.24f\n", "pentatonic", root)
    }
}
