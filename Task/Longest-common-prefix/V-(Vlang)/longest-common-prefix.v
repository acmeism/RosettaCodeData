// lcp finds the longest common prefix of the input strings.
fn lcp(l []string) string {
    // Special cases first
    match l.len {
        0 {
            return ""
        }
        1 {
            return l[0]
        }
        else {}
    }
    // LCP of min and max (lexigraphically)
    // is the LCP of the whole set.
    mut min, mut max := l[0], l[0]
    for s in l[1..] {
        if s < min {
            min = s
        } else if s > max {
            max = s
        }
    }
    for i := 0; i < min.len && i < max.len; i++ {
        if min[i] != max[i] {
            return min[..i]
        }
    }
    // In the case where lengths are not equal but all bytes
    // are equal, min is the answer ("foo" < "foobar").
    return min
}

// Normally something like this would be a TestLCP function in *_test.go
// and use the testing package to report failures.
fn main() {
    for l in [
        ["interspecies", "interstellar", "interstate"],
        ["throne", "throne"],
        ["throne", "dungeon"],
        ["throne", "", "throne"],
        ["cheese"],
        [""],
        []string{},
        ["prefix", "suffix"],
        ["foo", "foobar"],
     ] {
        println("lcp($l) = ${lcp(l)}")
    }
}
