fn chowla(n int) int {
    if n < 1 {
        panic("argument must be a positive integer")
    }
    mut sum := 0
    for i := 2; i*i <= n; i++ {
        if n%i == 0 {
            j := n / i
            if i == j {
                sum += i
            } else {
                sum += i + j
            }
        }
    }
    return sum
}

fn sieve(limit int) []bool {
    // True denotes composite, false denotes prime.
    // Only interested in odd numbers >= 3
    mut c := []bool{len: limit}
    for i := 3; i*3 < limit; i += 2 {
        if !c[i] && chowla(i) == 0 {
            for j := 3 * i; j < limit; j += 2 * i {
                c[j] = true
            }
        }
    }
    return c
}

fn main() {
    for i := 1; i <= 37; i++ {
        println("chowla(${i:2}) = ${chowla(i)}")
    }
    println('')

    mut count := 1
    mut limit := int(1e7)
    c := sieve(limit)
    mut power := 100
    for i := 3; i < limit; i += 2 {
        if !c[i] {
            count++
        }
        if i == power-1 {
            println("Count of primes up to ${power:-10} = $count")
            power *= 10
        }
    }

    println('')
    count = 0
    limit = 35000000
    for i := 2; ; i++ {
        p := (1 << (i -1)) * ((1<<i) - 1)
        if p > limit {
            break
        }
        if chowla(p) == p-1  {
            println("$p is a perfect number")
            count++
        }
    }
    println("There are $count perfect numbers <= 35,000,000")
}
