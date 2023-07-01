const d = [
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
    [1, 2, 3, 4, 0, 6, 7, 8, 9, 5],
    [2, 3, 4, 0, 1, 7, 8, 9, 5, 6],
    [3, 4, 0, 1, 2, 8, 9, 5, 6, 7],
    [4, 0, 1, 2, 3, 9, 5, 6, 7, 8],
    [5, 9, 8, 7, 6, 0, 4, 3, 2, 1],
    [6, 5, 9, 8, 7, 1, 0, 4, 3, 2],
    [7, 6, 5, 9, 8, 2, 1, 0, 4, 3],
    [8, 7, 6, 5, 9, 3, 2, 1, 0, 4],
    [9, 8, 7, 6, 5, 4, 3, 2, 1, 0],
]

const inv = [0, 4, 3, 2, 1, 5, 6, 7, 8, 9]

const p = [
    [0, 1, 2, 3, 4, 5, 6, 7, 8, 9],
    [1, 5, 7, 6, 2, 8, 3, 0, 9, 4],
    [5, 8, 0, 3, 7, 9, 6, 1, 4, 2],
    [8, 9, 1, 6, 0, 4, 3, 5, 2, 7],
    [9, 4, 5, 3, 1, 2, 6, 8, 7, 0],
    [4, 2, 8, 6, 5, 7, 3, 9, 0, 1],
    [2, 7, 9, 3, 8, 0, 6, 4, 1, 5],
    [7, 0, 4, 6, 9, 1, 3, 2, 5, 8],
]

fn verhoeff(ss string, validate bool, table bool) int {
    mut s:= ss
    if table {
        mut t := "Check digit"
        if validate {
            t = "Validation"
        }
        println("$t calculations for '$s':\n")
        println(" i  nᵢ  p[i,nᵢ]  c")
        println("------------------")
    }
    if !validate {
        s = s + "0"
    }
    mut c := 0
    le := s.len - 1
    for i := le; i >= 0; i-- {
        ni := int(s[i] - 48)
        pi := p[(le-i)%8][ni]
        c = d[c][pi]
        if table {
            println("${le-i:2}  $ni      $pi     $c")
        }
    }
    if table && !validate {
        println("\ninv[$c] = ${inv[c]}")
    }
    if !validate {
        return inv[c]
    }
    return int(c == 0)
}

fn main() {
    ss := ["236", "12345", "123456789012"]
    ts := [true, true, false, true]
    for i, s in ss {
        c := verhoeff(s, false, ts[i])
        println("\nThe check digit for '$s' is '$c'\n")
        for sc in [s + c.str(), s + "9"] {
            v := verhoeff(sc, true, ts[i])
            mut ans := "correct"
            if v==0 {
                ans = "incorrect"
            }
            println("\nThe validation for '$sc' is $ans\n")
        }
    }
}
