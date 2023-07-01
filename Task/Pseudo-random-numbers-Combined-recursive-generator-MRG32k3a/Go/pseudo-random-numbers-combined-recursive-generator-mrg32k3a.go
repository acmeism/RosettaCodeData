package main

import (
    "fmt"
    "log"
    "math"
)

var a1 = []int64{0, 1403580, -810728}
var a2 = []int64{527612, 0, -1370589}

const m1 = int64((1 << 32) - 209)
const m2 = int64((1 << 32) - 22853)
const d = m1 + 1

// Python style modulus
func mod(x, y int64) int64 {
    m := x % y
    if m < 0 {
        if y < 0 {
            return m - y
        } else {
            return m + y
        }
    }
    return m
}

type MRG32k3a struct{ x1, x2 [3]int64 }

func MRG32k3aNew() *MRG32k3a { return &MRG32k3a{} }

func (mrg *MRG32k3a) seed(seedState int64) {
    if seedState <= 0 || seedState >= d {
        log.Fatalf("Argument must be in the range [0, %d].\n", d)
    }
    mrg.x1 = [3]int64{seedState, 0, 0}
    mrg.x2 = [3]int64{seedState, 0, 0}
}

func (mrg *MRG32k3a) nextInt() int64 {
    x1i := mod(a1[0]*mrg.x1[0]+a1[1]*mrg.x1[1]+a1[2]*mrg.x1[2], m1)
    x2i := mod(a2[0]*mrg.x2[0]+a2[1]*mrg.x2[1]+a2[2]*mrg.x2[2], m2)
    mrg.x1 = [3]int64{x1i, mrg.x1[0], mrg.x1[1]} /* keep last three */
    mrg.x2 = [3]int64{x2i, mrg.x2[0], mrg.x2[1]} /* keep last three */
    return mod(x1i-x2i, m1) + 1
}

func (mrg *MRG32k3a) nextFloat() float64 { return float64(mrg.nextInt()) / float64(d) }

func main() {
    randomGen := MRG32k3aNew()
    randomGen.seed(1234567)
    for i := 0; i < 5; i++ {
        fmt.Println(randomGen.nextInt())
    }

    var counts [5]int
    randomGen.seed(987654321)
    for i := 0; i < 1e5; i++ {
        j := int(math.Floor(randomGen.nextFloat() * 5))
        counts[j]++
    }
    fmt.Println("\nThe counts for 100,000 repetitions are:")
    for i := 0; i < 5; i++ {
        fmt.Printf("  %d : %d\n", i, counts[i])
    }
}
