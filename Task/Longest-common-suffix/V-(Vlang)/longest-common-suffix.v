fn lcs(a []string) string {
    // Special cases first
    match a.len {
        0 {
            return ""
        }
        1 {
            return a[0]
        }
        else {}
    }
    le0 := a[0].len
    mut min_len := le0
    for i in 1..a.len {
        if a[i].len < min_len {
            min_len = a[i].len
        }
    }
    if min_len == 0 {
        return ""
    }
    mut res := ""
    a1 := a[1..]
    for i := 1; i <= min_len; i++ {
        suffix := a[0][le0-i..]
        for e in a1 {
            if e.index(suffix) or {0} + suffix.len != e.len {
                return res
            }
        }
        res = suffix
    }
    return res
}

// Normally something like this would be a Testlcs function in *_test.go
// and use the testing package to report failures.
fn main() {
    for l in [
        ["baabababc", "baabc", "bbbabc"],
        ["baabababc", "baabc", "bbbazc"],
        ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday"],
        ["longest", "common", "suffix"],
        ["suffix"],
        [""],
     ] {
        println("lcs($l) = ${lcs(l)}")
    }
}
