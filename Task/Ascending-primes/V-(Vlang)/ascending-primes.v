fn is_prime(n int) bool {
    if n < 2 {
        return false
    } else if n%2 == 0 {
        return n == 2
    } else if n%3 == 0 {
        return n == 3
    } else {
        mut d := 5
        for d*d <= n {
            if n%d == 0 {
                return false
            }
            d += 2
            if n%d == 0 {
                return false
            }
            d += 4
        }
        return true
    }
}
fn generate(first int, cand int, digits int, mut asc map[int]bool) {
    if digits == 0 {
        if is_prime(cand) {
            asc[cand] = true
        }
        return
    }
    for i in first..10 {
        next := cand*10 + i
        generate(i+1, next, digits-1, mut asc)
    }
}

fn main() {
    mut asc_primes_set := map[int]bool{} // avoids duplicates

    for digits in 1..10 {
        generate(1, 0, digits, mut asc_primes_set)
    }
    le := asc_primes_set.keys().len
    mut asc_primes := []int{len: le}
    mut i := 0
    for k,_ in asc_primes_set {
        asc_primes[i] = k
        i++
    }
    asc_primes.sort()
    println("There are $le ascending primes, namely:")
    for q in 0..le {
        print("${asc_primes[q]:8} ")
        if (q+1)%10 == 0 {
            println('')
        }
    }
}
