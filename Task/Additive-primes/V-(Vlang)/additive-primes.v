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

fn sum_digits(nn int) int {
    mut n := nn
    mut sum := 0
    for n > 0 {
        sum += n % 10
        n /= 10
    }
    return sum
}

fn main() {
    println("Additive primes less than 500:")
    mut i := 2
    mut count := 0
    for {
        if is_prime(i) && is_prime(sum_digits(i)) {
            count++
            print("${i:3}  ")
            if count%10 == 0 {
                println('')
            }
        }
        if i > 2 {
            i += 2
        } else {
            i++
        }
        if i > 499 {
            break
        }
    }
    println("\n\n$count additive primes found.")
}
