fn divisors(n i64) []i64 {
    mut divs := [i64(1)]
    mut divs2 := []i64{}
    for i := 2; i*i <= n; i++ {
        if n%i == 0 {
            j := n / i
            divs << i
            if i != j {
                divs2 << j
            }
        }
    }
    for i := divs2.len - 1; i >= 0; i-- {
        divs << divs2[i]
    }
    return divs
}

fn sum(divs []i64) i64 {
    mut tot := i64(0)
    for div in divs {
        tot += div
    }
    return tot
}

fn sum_str(divs []i64) string {
    mut s := ""
    for div in divs {
        s += "${u8(div)} + "
    }
    return s[0..s.len-3]
}

fn abundant_odd(search_from i64, count_from int, count_to int, print_one bool) i64 {
    mut count := count_from
    mut n := search_from
    for ; count < count_to; n += 2 {
        divs := divisors(n)
        tot := sum(divs)
        if tot > n {
            count++
            if print_one && count < count_to {
                continue
            }
            s := sum_str(divs)
            if !print_one {
                println("${count:2}. ${n:5} < $s = $tot")
            } else {
                println("$n < $s = $tot")
            }
        }
    }
    return n
}

const max = 25

fn main() {
    println("The first $max abundant odd numbers are:")
    n := abundant_odd(1, 0, 25, false)

    println("\nThe one thousandth abundant odd number is:")
    abundant_odd(n, 25, 1000, true)

    println("\nThe first abundant odd number above one billion is:")
    abundant_odd(1_000_000_001, 0, 1, true)
}
