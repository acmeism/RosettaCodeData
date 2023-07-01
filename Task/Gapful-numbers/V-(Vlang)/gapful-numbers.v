fn commatize(n u64) string {
    mut s := n.str()
    le := s.len
    for i := le - 3; i >= 1; i -= 3 {
        s = '${s[0..i]},$s[i..]'
    }
    return s
}

fn main() {
    starts := [u64(1e2), u64(1e6), u64(1e7), u64(1e9), u64(7123)]
    counts := [30, 15, 15, 10, 25]
    for i in 0..starts.len {
        mut count := 0
        mut j := starts[i]
        mut pow := u64(100)
        for {
            if j < pow*10 {
                break
            }
            pow *= 10
        }
        println("First ${counts[i]} gapful numbers starting at ${commatize(starts[i])}:")
        for count < counts[i] {
            fl := (j/pow)*10 + (j % 10)
            if j%fl == 0 {
                print("$j ")
                count++
            }
            j++
            if j >= 10*pow {
                pow *= 10
            }
        }
        println("\n")
    }
}
