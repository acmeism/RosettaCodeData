package main

import (
    "fmt"
    "math/big"
)

const branches = 4
const nMax = 500

var rooted, unrooted [nMax + 1]big.Int
var c [branches]big.Int
var tmp = new(big.Int)
var one = big.NewInt(1)

func tree(br, n, l, sum int, cnt *big.Int) {
    for b := br + 1; b <= branches; b++ {
        sum += n
        if sum > nMax {
            return
        }
        if l*2 >= sum && b >= branches {
            return
        }
        if b == br+1 {
            c[br].Mul(&rooted[n], cnt)
        } else {
            tmp.Add(&rooted[n], tmp.SetInt64(int64(b-br-1)))
            c[br].Mul(&c[br], tmp)
            c[br].Div(&c[br], tmp.SetInt64(int64(b-br)))
        }
        if l*2 < sum {
            unrooted[sum].Add(&unrooted[sum], &c[br])
        }
        if b < branches {
            rooted[sum].Add(&rooted[sum], &c[br])
        }
        for m := n - 1; m > 0; m-- {
            tree(b, m, l, sum, &c[br])
        }
    }
}

func bicenter(s int) {
    if s&1 == 0 {
        tmp.Rsh(tmp.Mul(&rooted[s/2], tmp.Add(&rooted[s/2], one)), 1)
        unrooted[s].Add(&unrooted[s], tmp)
    }
}

func main() {
    rooted[0].SetInt64(1)
    rooted[1].SetInt64(1)
    unrooted[0].SetInt64(1)
    unrooted[1].SetInt64(1)
    for n := 1; n <= nMax; n++ {
        tree(0, n, n, 1, big.NewInt(1))
        bicenter(n)
        fmt.Printf("%d: %d\n", n, &unrooted[n])
    }
}
