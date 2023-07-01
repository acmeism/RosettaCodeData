fn is_prime(n int) bool {
    if n < 2 {
        return false
    }
    else if n%2 == 0 {
        return n == 2
    }
    else if n%3 == 0 {
        return n == 3
    }
    else {
        mut d := 5
        for  d*d <= n {
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

fn count_prime_factors(n int) int {
    mut nn := n
    if n == 1 {
        return 0
    }
    else if is_prime(nn) {
        return 1
    }
    else {
        mut count, mut f := 0, 2
        for {
            if nn%f == 0 {
                count++
                nn /= f
                if nn == 1{
                    return count
                }
                if is_prime(nn) {
                    f = nn
                }
            } else if f >= 3{
                f += 2
            } else {
                f = 3
            }
        }
        return count
    }
}

fn main() {
    max := 120
    println('The attractive numbers up to and including $max are:')
    mut count := 0
    for i in 1 .. max+1 {
        n := count_prime_factors(i)
        if is_prime(n) {
            print('${i:4}')
            count++
            if count%20 == 0 {
                println('')
            }
        }
    }
}
