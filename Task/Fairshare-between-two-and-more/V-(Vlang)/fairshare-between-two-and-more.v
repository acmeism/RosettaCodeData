fn fairshare(n int, base int) []int {
    mut res := []int{len: n}
    for i in 0..n {
        mut j := i
        mut sum := 0
        for j > 0 {
            sum += j % base
            j /= base
        }
        res[i] = sum % base
    }
    return res
}

fn turns(n int, fss []int) string {
    mut m := map[int]int{}
    for fs in fss {
        m[fs]++
    }
    mut m2 := map[int]int{}
    for _,v in m {
        m2[v]++
    }
    mut res := []int{}
    mut sum := 0
    for k, v in m2 {
        sum += v
        res << k
    }
    if sum != n {
        return "only $sum have a turn"
    }
    res.sort()
    mut res2 := []string{len: res.len}
    for i,_ in res {
        res2[i] = '${res[i]}'
    }
    return res2.join(" or ")
}

fn main() {
    for base in [2, 3, 5, 11] {
        println("${base:2} : ${fairshare(25, base):2}")
    }
    println("\nHow many times does each get a turn in 50000 iterations?")
    for base in [191, 1377, 49999, 50000, 50001] {
        t := turns(base, fairshare(50000, base))
        println("  With $base people: $t")
    }
}
