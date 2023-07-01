package main

import (
    "fmt"
    "math/big"
    "strings"
)

var zero = new(big.Int)
var one = big.NewInt(1)

func toEgyptianRecursive(br *big.Rat, fracs []*big.Rat) []*big.Rat {
    if br.Num().Cmp(zero) == 0 {
        return fracs
    }
    iquo := new(big.Int)
    irem := new(big.Int)
    iquo.QuoRem(br.Denom(), br.Num(), irem)
    if irem.Cmp(zero) > 0 {
        iquo.Add(iquo, one)
    }
    rquo := new(big.Rat).SetFrac(one, iquo)
    fracs = append(fracs, rquo)
    num2 := new(big.Int).Neg(br.Denom())
    num2.Rem(num2, br.Num())
    if num2.Cmp(zero) < 0 {
        num2.Add(num2, br.Num())
    }
    denom2 := new(big.Int)
    denom2.Mul(br.Denom(), iquo)
    f := new(big.Rat).SetFrac(num2, denom2)
    if f.Num().Cmp(one) == 0 {
        fracs = append(fracs, f)
        return fracs
    }
    fracs = toEgyptianRecursive(f, fracs)
    return fracs
}

func toEgyptian(rat *big.Rat) []*big.Rat {
    if rat.Num().Cmp(zero) == 0 {
        return []*big.Rat{rat}
    }
    var fracs []*big.Rat
    if rat.Num().CmpAbs(rat.Denom()) >= 0 {
        iquo := new(big.Int)
        iquo.Quo(rat.Num(), rat.Denom())
        rquo := new(big.Rat).SetFrac(iquo, one)
        rrem := new(big.Rat)
        rrem.Sub(rat, rquo)
        fracs = append(fracs, rquo)
        fracs = toEgyptianRecursive(rrem, fracs)
    } else {
        fracs = toEgyptianRecursive(rat, fracs)
    }
    return fracs
}

func main() {
    fracs := []*big.Rat{big.NewRat(43, 48), big.NewRat(5, 121), big.NewRat(2014, 59)}
    for _, frac := range fracs {
        list := toEgyptian(frac)
        if list[0].Denom().Cmp(one) == 0 {
            first := fmt.Sprintf("[%v]", list[0].Num())
            temp := make([]string, len(list)-1)
            for i := 1; i < len(list); i++ {
                temp[i-1] = list[i].String()
            }
            rest := strings.Join(temp, " + ")
            fmt.Printf("%v -> %v + %s\n", frac, first, rest)
        } else {
            temp := make([]string, len(list))
            for i := 0; i < len(list); i++ {
                temp[i] = list[i].String()
            }
            all := strings.Join(temp, " + ")
            fmt.Printf("%v -> %s\n", frac, all)
        }
    }

    for _, r := range [2]int{98, 998} {
        if r == 98 {
            fmt.Println("\nFor proper fractions with 1 or 2 digits:")
        } else {
            fmt.Println("\nFor proper fractions with 1, 2 or 3 digits:")
        }
        maxSize := 0
        var maxSizeFracs []*big.Rat
        maxDen := zero
        var maxDenFracs []*big.Rat
        var sieve = make([][]bool, r+1) // to eliminate duplicates
        for i := 0; i <= r; i++ {
            sieve[i] = make([]bool, r+2)
        }
        for i := 1; i <= r; i++ {
            for j := i + 1; j <= r+1; j++ {
                if sieve[i][j] {
                    continue
                }
                f := big.NewRat(int64(i), int64(j))
                list := toEgyptian(f)
                listSize := len(list)
                if listSize > maxSize {
                    maxSize = listSize
                    maxSizeFracs = maxSizeFracs[0:0]
                    maxSizeFracs = append(maxSizeFracs, f)
                } else if listSize == maxSize {
                    maxSizeFracs = append(maxSizeFracs, f)
                }
                listDen := list[len(list)-1].Denom()
                if listDen.Cmp(maxDen) > 0 {
                    maxDen = listDen
                    maxDenFracs = maxDenFracs[0:0]
                    maxDenFracs = append(maxDenFracs, f)
                } else if listDen.Cmp(maxDen) == 0 {
                    maxDenFracs = append(maxDenFracs, f)
                }
                if i < r/2 {
                    k := 2
                    for {
                        if j*k > r+1 {
                            break
                        }
                        sieve[i*k][j*k] = true
                        k++
                    }
                }
            }
        }
        fmt.Println("  largest number of items =", maxSize)
        fmt.Println("  fraction(s) with this number :", maxSizeFracs)
        md := maxDen.String()
        fmt.Print("  largest denominator = ", len(md), " digits, ")
        fmt.Print(md[0:20], "...", md[len(md)-20:], "\b\n")
        fmt.Println("  fraction(s) with this denominator :", maxDenFracs)
    }
}
