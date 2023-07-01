import strconv

fn kaprekar(n u64, base u64) (bool, int) {
    mut order := 0
    if n == 1 {
        return true, -1
    }

    nn, mut power := n*n, u64(1)
    for power <= nn {
        power *= base
        order++
    }

    power /= base
    order--
    for ; power > 1; power /= base {
        q, r := nn/power, nn%power
        if q >= n {
            return false, -1
        }

        if q+r == n {
            return true, order
        }

        order--
    }

    return false, -1
}

fn main() {
    mut max := u64(10000)
    println("Kaprekar numbers < $max:")
    for m := u64(0); m < max; m++ {
        isk, _ := kaprekar(m, 10)
        if isk {
            println("  $m")
        }
    }

    // extra credit
    max = u64(1e6)
    mut count := 0
    for m := u64(0); m < max; m++ {
        isk, _ := kaprekar(m, 10)
        if isk {
            count++
        }
    }
    println("\nThere are $count Kaprekar numbers < ${max}.")

    // extra extra credit
    base := 17
    max_b := "1000000"
    println("\nKaprekar numbers between 1 and ${max_b}(base ${base}):")
    max, _ = strconv.common_parse_uint2(max_b, base, 64)
    println("\n Base 10  Base ${base}        Square       Split")
    for m := u64(2); m < max; m++ {
        isk, pos := kaprekar(m, u64(base))
        if !isk {
            continue
        }
        sq := strconv.format_uint(m*m, base)
        str := strconv.format_uint(m, base)
        split := sq.len-pos
        println("${m:8}  ${str:7}  ${sq:12}  ${sq[..split]:6} + ${sq[split..]}") // optional extra extra credit
    }
}
