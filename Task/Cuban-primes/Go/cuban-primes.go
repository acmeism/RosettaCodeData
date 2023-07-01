package main

import (
    "fmt"
    "math/big"
)

func commatize(n uint64) string {
    s := fmt.Sprintf("%d", n)
    le := len(s)
    for i := le - 3; i >= 1; i -= 3 {
        s = s[0:i] + "," + s[i:]
    }
    return s
}

func main() {
    var z big.Int
    var cube1, cube2, cube100k, diff uint64
    cubans := make([]string, 200)
    cube1 = 1
    count := 0
    for i := 1; ; i++ {
        j := i + 1
        cube2 = uint64(j * j * j)
        diff = cube2 - cube1
        z.SetUint64(diff)
        if z.ProbablyPrime(0) { // 100% accurate for z < 2 ^ 64
            if count < 200 {
                cubans[count] = commatize(diff)
            }
            count++
            if count == 100000 {
                cube100k = diff
                break
            }
        }
        cube1 = cube2
    }
    fmt.Println("The first 200 cuban primes are:-")
    for i := 0; i < 20; i++ {
        j := i * 10
        fmt.Printf("%9s\n", cubans[j : j+10]) // 10 per line say
    }
    fmt.Println("\nThe 100,000th cuban prime is", commatize(cube100k))
}
