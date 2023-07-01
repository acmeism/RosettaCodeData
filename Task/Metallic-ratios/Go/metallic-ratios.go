package main

import (
    "fmt"
    "math/big"
)

var names = [10]string{"Platinum", "Golden", "Silver", "Bronze", "Copper",
    "Nickel", "Aluminium", "Iron", "Tin", "Lead"}

func lucas(b int64) {
    fmt.Printf("Lucas sequence for %s ratio, where b = %d:\n", names[b], b)
    fmt.Print("First 15 elements: ")
    var x0, x1 int64 = 1, 1
    fmt.Printf("%d, %d", x0, x1)
    for i := 1; i <= 13; i++ {
        x2 := b*x1 + x0
        fmt.Printf(", %d", x2)
        x0, x1 = x1, x2
    }
    fmt.Println()
}

func metallic(b int64, dp int) {
    x0, x1, x2, bb := big.NewInt(1), big.NewInt(1), big.NewInt(0), big.NewInt(b)
    ratio := big.NewRat(1, 1)
    iters := 0
    prev := ratio.FloatString(dp)
    for {
        iters++
        x2.Mul(bb, x1)
        x2.Add(x2, x0)
        this := ratio.SetFrac(x2, x1).FloatString(dp)
        if prev == this {
            plural := "s"
            if iters == 1 {
                plural = " "
            }
            fmt.Printf("Value to %d dp after %2d iteration%s: %s\n\n", dp, iters, plural, this)
            return
        }
        prev = this
        x0.Set(x1)
        x1.Set(x2)
    }
}

func main() {
    for b := int64(0); b < 10; b++ {
        lucas(b)
        metallic(b, 32)
    }
    fmt.Println("Golden ratio, where b = 1:")
    metallic(1, 256)
}
