import time
fn ulam(n int) int {
    mut ulams := [1, 2]
    mut sieve := [1, 1]
    mut u := 2
    for ulams.len < n {
        s := u + ulams[ulams.len-2]
        t := s - sieve.len
        for i := 0; i < t; i++ {
            sieve << 0
        }
        for i := 1; i <= ulams.len-1; i++ {
            v := u + ulams[i-1] - 1
            sieve[v]++
        }
        mut index := -1
        for i, e in sieve[u..] {
            if e == 1 {
                index = u + i
                break
            }
        }
        u = index + 1
        ulams << u
    }
    return ulams[n-1]
}

fn commatize(n int) string {
    mut s := '$n'
    if n < 0 {
        s = s[1..]
    }
    le := s.len
    for i := le - 3; i >= 1; i -= 3 {
        s = '${s[0..i]},${s[i..]}'
    }
    if n >= 0 {
        return s
    }
    return "-$s"
}

fn main() {
    start := time.now()
    for n := 1; n <= 10000; n *= 10 {
        mut s := "th"
        if n == 1 {
            s = "st"
        }
        println("The ${commatize(n)}$s Ulam number is ${commatize(ulam(n))}")
    }
    println("\nTook ${time.since(start)}")
}
