import math
const threshold = u64(1) << 47

fn index_of(s []u64, search u64) int {
    for i, e in s {
        if e == search {
            return i
        }
    }
    return -1
}

fn contains(s []u64, search u64) bool {
    return index_of(s, search) > -1
}

fn max_of(i1 int, i2 int) int {
    if i1 > i2 {
        return i1
    }
    return i2
}

fn sum_proper_divisors(n u64) u64 {
    if n < 2 {
        return 0
    }
    sqrt := u64(math.sqrt(f64(n)))
    mut sum := u64(1)
    for i := u64(2); i <= sqrt; i++ {
        if n % i != 0 {
            continue
        }
        sum += i + n / i
    }
    if sqrt * sqrt == n {
        sum -= sqrt
    }
    return sum
}

fn classify_sequence(k u64) ([]u64, string) {
    if k == 0 {
        panic("Argument must be positive.")
    }
    mut last := k
    mut seq := []u64{}
    seq << k
    for {
        last = sum_proper_divisors(last)
        seq << last
        n := seq.len
        mut aliquot := ""
        match true {
            last == 0 {
                aliquot = "Terminating"
            }
            n == 2 && last == k {
                aliquot = "Perfect"
            }
            n == 3 && last == k {
                aliquot = "Amicable"
            }
            n >= 4 && last == k {
                aliquot = "Sociable[${n-1}]"
            }
            last == seq[n - 2] {
                aliquot = "Aspiring"
            }
            contains(seq[1 .. max_of(1, n - 2)], last) {
                aliquot = "Cyclic[${n - 1 - index_of(seq, last)}]"
            }
            n == 16 || last > threshold {
                aliquot = "Non-Terminating"
            }
            else {}
        }
        if aliquot != "" {
            return seq, aliquot
        }
    }
    return seq, ''
}

fn main() {
    println("Aliquot classifications - periods for Sociable/Cyclic in square brackets:\n")
    for k := u64(1); k <= 10; k++ {
        seq, aliquot := classify_sequence(k)
        println("${k:2}: ${aliquot:-15} $seq")
    }
    println('')

    s := [
        u64(11), 12, 28, 496, 220, 1184, 12496, 1264460, 790, 909, 562, 1064, 1488,
    ]
    for k in s {
        seq, aliquot := classify_sequence(k)
        println("${k:7}: ${aliquot:-15} $seq")
    }
    println('')

    k := u64(15355717786080)
    seq, aliquot := classify_sequence(k)
    println("$k: ${aliquot:-15} $seq")
}
