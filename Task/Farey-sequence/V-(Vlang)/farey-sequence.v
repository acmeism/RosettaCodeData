struct Frac {
    num int
    den int
}

fn (f Frac) str() string {
    return "$f.num/$f.den"
}

fn f(l Frac, r Frac, n int) {
    m := Frac{l.num + r.num, l.den + r.den}
    if m.den <= n {
        f(l, m, n)
        print("$m ")
        f(m, r, n)
    }
}

fn main() {
    // task 1.  solution by recursive generation of mediants
    for n := 1; n <= 11; n++ {
        l := Frac{0, 1}
        r := Frac{1, 1}
        print("F($n): $l ")
        f(l, r, n)
        println(r)
    }
    // task 2.  direct solution by summing totient fntion
    // 2.1 generate primes to 1000
    mut composite := [1001]bool{}
    for p in [2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31] {
        for n := p * 2; n <= 1000; n += p {
            composite[n] = true
        }
    }
    // 2.2 generate totients to 1000
    mut tot := [1001]int{init: 1}
    for n := 2; n <= 1000; n++ {
        if !composite[n] {
            tot[n] = n - 1
            for a := n * 2; a <= 1000; a += n {
                mut f := n - 1
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
            println("|F($n)|: $sum")
        }
    }
}
