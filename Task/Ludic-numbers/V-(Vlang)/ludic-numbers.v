const max_i32 = 1<<31 - 1 // i.e. math.MaxInt32
// ludic returns a slice of ludic numbers stopping after
// either n entries or when max is exceeded.
// Either argument may be <=0 to disable that limit.
fn ludic(nn int, m int) []u32 {
    mut n := nn
    mut max := m
    if max > 0 && n < 0 {
        n = max_i32
    }
    if n < 1 {
        return []
    }
    if max < 0 {
        max = max_i32
    }
    mut sieve := []u32{len: 10760} // XXX big enough for 2005 ludics
    sieve[0] = 1
    sieve[1] = 2
    if n > 2 {
        // We start with even numbers already removed
        for i, j := 2, u32(3); i < sieve.len; i, j = i+1, j+2 {
            sieve[i] = j
        }
        // We leave the ludic numbers in place,
        // k is the index of the next ludic
        for k := 2; k < n; k++ {
            mut l := int(sieve[k])
            if l >= max {
                n = k
                break
            }
            mut i := l
            l--
            // last is the last valid index
            mut last := k + i - 1
            for j := k + i + 1; j < sieve.len; i, j = i+1, j+1 {
                last = k + i
                sieve[last] = sieve[j]
                if i%l == 0 {
                    j++
                }
            }
            // Truncate down to only the valid entries
            if last < sieve.len-1 {
                sieve = sieve[..last+1]
            }
        }
    }
    if n > sieve.len {
        panic("program error") // should never happen
    }
    return sieve[..n]
}

fn has(x []u32, v u32) bool {
    for i := 0; i < x.len && x[i] <= v; i++ {
        if x[i] == v {
            return true
        }
    }
    return false
}

fn main() {
    // ludic() is so quick we just call it repeatedly
    println("First 25: ${ludic(25, -1)}")
    println("Numner of ludics below 1000: ${ludic(-1, 1000).len}")
    println("ludic 2000 to 2005: ${ludic(2005, -1)[1999..]}")

    print("Tripples below 250:")
    x := ludic(-1, 250)
    for i, v in x[..x.len-2] {
        if has(x[i+1..], v+2) && has(x[i+2..], v+6) {
            print(", ($v ${v+2} ${v+6})")
        }
    }
    println('')
}
