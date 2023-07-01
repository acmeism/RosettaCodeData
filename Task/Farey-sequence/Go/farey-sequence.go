package main

import "fmt"

type frac struct{ num, den int }

func (f frac) String() string {
    return fmt.Sprintf("%d/%d", f.num, f.den)
}

func f(l, r frac, n int) {
    m := frac{l.num + r.num, l.den + r.den}
    if m.den <= n {
        f(l, m, n)
        fmt.Print(m, " ")
        f(m, r, n)
    }
}

func main() {
    // task 1.  solution by recursive generation of mediants
    for n := 1; n <= 11; n++ {
        l := frac{0, 1}
        r := frac{1, 1}
        fmt.Printf("F(%d): %s ", n, l)
        f(l, r, n)
        fmt.Println(r)
    }
    // task 2.  direct solution by summing totient function
    // 2.1 generate primes to 1000
    var composite [1001]bool
    for _, p := range []int{2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31} {
        for n := p * 2; n <= 1000; n += p {
            composite[n] = true
        }
    }
    // 2.2 generate totients to 1000
    var tot [1001]int
    for i := range tot {
        tot[i] = 1
    }
    for n := 2; n <= 1000; n++ {
        if !composite[n] {
            tot[n] = n - 1
            for a := n * 2; a <= 1000; a += n {
                f := n - 1
                for r := a / n; r%n == 0; r /= n {
                    f *= n
                }
                tot[a] *= f
            }
        }
    }
    // 2.3 sum totients
    for n, sum := 1, 1; n <= 1000; n++ {
        sum += tot[n]
        if n%100 == 0 {
            fmt.Printf("|F(%d)|: %d\n", n, sum)
        }
    }
}
