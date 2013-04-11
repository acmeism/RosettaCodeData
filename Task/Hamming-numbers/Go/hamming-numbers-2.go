package main

import (
    "flag"
    "fmt"
    "math"
    "math/big"
    "os"
)

var ordinal int       // ordinal of last sequence element to compute
var sequenceMode bool // print the whole sequence or just one element?

var lg3, lg5 float64 // precomputed base-2 logarithms for 3 and 5

var table [][3]int16 // table for dynamic-programming stored results
var front [3]cursor  // state of the three multiplied sequences

type cursor struct {
    f  int     // index (0, 1, 2) corresponding to factor (2, 3, 5)
    i  int     // index into table for the entry being multiplied
    lg float64 // base-2 logarithm of the multiple (for ordering)
}

func (c *cursor) value() [3]int16 {
    x := table[c.i]
    x[c.f]++ // multiply by incrementing the exponent
    return x
}

func (c *cursor) advance() {
    c.i++
    // skip entries that would produce duplicates
    for (c.f < 2 && table[c.i][2] > 0) || (c.f < 1 && table[c.i][1] > 0) {
        c.i++
    }
    x := c.value()
    c.lg = float64(x[0]) + lg3*float64(x[1]) + lg5*float64(x[2])
}

func step() {
    table = append(table, front[0].value())
    front[0].advance()
    // re-establish sorted order
    if front[0].lg > front[1].lg {
        front[0], front[1] = front[1], front[0]
        if front[1].lg > front[2].lg {
            front[1], front[2] = front[2], front[1]
        }
    }
}
func show(elem [3]int16) {
    z := big.NewInt(1)
    for i, base := range []int64{2, 3, 5} {
        b := big.NewInt(base)
        x := big.NewInt(int64(elem[i]))
        z.Mul(z, b.Exp(b, x, nil))
    }
    fmt.Println(z)
}

func fail(msg string) {
    fmt.Fprintf(os.Stderr, "%s: %s\n", os.Args[0], msg)
    os.Exit(1)
}

func parse() {
    flag.Parse()
    if flag.NArg() != 1 {
        fail("need one argument")
    }
    _, err := fmt.Sscan(flag.Arg(0), &ordinal)
    if err != nil || ordinal <= 0 {
        fail("argument must be a positive integer")
    }
}

func init() {
    flag.BoolVar(&sequenceMode, "s", false, "sequence mode")
    lg3 = math.Log2(3)
    lg5 = math.Log2(5)
    front = [3]cursor{
        {0, 0, 1},   // 2
        {1, 0, lg3}, // 3
        {2, 0, lg5}, // 5
    }
}

func main() {
    parse()
    table = make([][3]int16, 1, ordinal)
    for i, n := 1, ordinal; i < n; i++ {
        if sequenceMode {
            show(table[i-1])
        }
        step()
    }
    show(table[ordinal-1])
}
