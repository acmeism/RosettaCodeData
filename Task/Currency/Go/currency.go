package main

import (
    "fmt"
    "log"
    "math/big"
)

// DC for dollars and cents.  Value is an integer number of cents.
type DC int64

func (dc DC) String() string {
    d := dc / 100
    if dc < 0 {
        dc = -dc
    }
    return fmt.Sprintf("%d.%02d", d, dc%100)
}

// Extend returns extended price of a unit price.
func (dc DC) Extend(n int) DC {
    return dc * DC(n)
}

var one = big.NewInt(1)
var hundred = big.NewRat(100, 1)

// ParseDC parses dollars and cents as a string into a DC.
func ParseDC(s string) (DC, bool) {
    r, ok := new(big.Rat).SetString(s)
    if !ok {
        return 0, false
    }
    r.Mul(r, hundred)
    if r.Denom().Cmp(one) != 0 {
        return 0, false
    }
    return DC(r.Num().Int64()), true
}

// TR for tax rate.  Value is an an exact rational.
type TR struct {
    *big.Rat
}
func NewTR() TR {
    return TR{new(big.Rat)}
}

// SetString overrides Rat.SetString to return the TR type.
func (tr TR) SetString(s string) (TR, bool) {
    if _, ok := tr.Rat.SetString(s); !ok {
        return TR{}, false
    }
    return tr, true
}

var half = big.NewRat(1, 2)

// Tax computes a tax amount, rounding to the nearest cent.
func (tr TR) Tax(dc DC) DC {
    r := big.NewRat(int64(dc), 1)
    r.Add(r.Mul(r, tr.Rat), half)
    return DC(new(big.Int).Div(r.Num(), r.Denom()).Int64())
}

func main() {
    hamburgerPrice, ok := ParseDC("5.50")
    if !ok {
        log.Fatal("Invalid hamburger price")
    }
    milkshakePrice, ok := ParseDC("2.86")
    if !ok {
        log.Fatal("Invalid milkshake price")
    }
    taxRate, ok := NewTR().SetString("0.0765")
    if !ok {
        log.Fatal("Invalid tax rate")
    }

    totalBeforeTax := hamburgerPrice.Extend(4000000000000000) +
        milkshakePrice.Extend(2)
    tax := taxRate.Tax(totalBeforeTax)
    total := totalBeforeTax + tax

    fmt.Printf("Total before tax: %22s\n", totalBeforeTax)
    fmt.Printf("             Tax: %22s\n", tax)
    fmt.Printf("           Total: %22s\n", total)
}
