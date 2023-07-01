fn get_divisors(n int) []int {
    mut divs := [1, n]
    for i := 2; i*i <= n; i++ {
        if n%i == 0 {
            j := n / i
            divs << i
            if i != j {
                divs << j
            }
        }
    }
    return divs
}

fn sum(divs []int) int {
    mut sum := 0
    for div in divs {
        sum += div
    }
    return sum
}

fn is_part_sum(d []int, sum int) bool {
    mut divs := d.clone()
    if sum == 0 {
        return true
    }
    le := divs.len
    if le == 0 {
        return false
    }
    last := divs[le-1]
    divs = divs[0 .. le-1]
    if last > sum {
        return is_part_sum(divs, sum)
    }
    return is_part_sum(divs, sum) || is_part_sum(divs, sum-last)
}

fn is_zumkeller(n int) bool {
    divs := get_divisors(n)
    s := sum(divs)
    // if sum is odd can't be split into two partitions with equal sums
    if s%2 == 1 {
        return false
    }
    // if n is odd use 'abundant odd number' optimization
    if n%2 == 1 {
        abundance := s - 2*n
        return abundance > 0 && abundance%2 == 0
    }
    // if n and sum are both even check if there's a partition which totals sum / 2
    return is_part_sum(divs, s/2)
}

fn main() {
    println("The first 220 Zumkeller numbers are:")
    for i, count := 2, 0; count < 220; i++ {
        if is_zumkeller(i) {
            print("${i:3} ")
            count++
            if count%20 == 0 {
                println('')
            }
        }
    }
    println("\nThe first 40 odd Zumkeller numbers are:")
    for i, count := 3, 0; count < 40; i += 2 {
        if is_zumkeller(i) {
            print("${i:5} ")
            count++
            if count%10 == 0 {
                println('')
            }
        }
    }
    println("\nThe first 40 odd Zumkeller numbers which don't end in 5 are:")
    for i, count := 3, 0; count < 40; i += 2 {
        if (i % 10 != 5) && is_zumkeller(i) {
            print("${i:7} ")
            count++
            if count%8 == 0 {
                println('')
            }
        }
    }
    println('')
}
