fn divisors(n int) []int {
    mut divs := [1]
    mut divs2 := []int{}
    for i := 2; i*i <= n; i++ {
        if n%i == 0 {
            j := n / i
            divs << i
            if i != j {
                divs2 << j
            }
        }
    }
    for i := divs.len - 1; i >= 0; i-- {
        divs2 << divs[i]
    }
    return divs2
}

fn abundant(n int, divs []int) bool {
    mut sum := 0
    for div in divs {
        sum += div
    }
    return sum > n
}

fn semiperfect(n int, divs []int) bool {
    le := divs.len
    if le > 0 {
        h := divs[0]
        t := divs[1..]
        if n < h {
            return semiperfect(n, t)
        } else {
            return n == h || semiperfect(n-h, t) || semiperfect(n, t)
        }
    } else {
        return false
    }
}

fn sieve(limit int) []bool {
    // false denotes abundant and not semi-perfect.
    // Only interested in even numbers >= 2
    mut w := []bool{len: limit}
    for i := 2; i < limit; i += 2 {
        if w[i] {
            continue
        }
        divs := divisors(i)
        if !abundant(i, divs) {
            w[i] = true
        } else if semiperfect(i, divs) {
            for j := i; j < limit; j += i {
                w[j] = true
            }
        }
    }
    return w
}

fn main() {
    w := sieve(17000)
    mut count := 0
    max := 25
    println("The first 25 weird numbers are:")
    for n := 2; count < max; n += 2 {
        if !w[n] {
            print("$n ")
            count++
        }
    }
    println('')
}
