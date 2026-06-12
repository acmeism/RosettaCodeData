import time
fn ulam(n int) int {
    if n <= 2 {
        return n
    }
    max := 1_352_000
    mut list := []int{len:max+1}
    list[0], list[1] = 1, 2
    mut sums := []u8{len:2*max+1}
    sums[3] = 1
    mut size := 2
    mut query := 0
    for {
        query = list[size-1] + 1
        for {
            if sums[query] == 1 {
                for i in 0..size {
                    sum := query + list[i]
                    t := sums[sum] + 1
                    if t <= 2 {
                        sums[sum] = t
                    }
                }
                list[size] = query
                size++
                break
            }
            query++
        }
        if size >= n {
            break
        }
    }
    return query
}

fn commatize(n int) string {
    mut s := '$n'
    if n < 0 {
        s = s[1..]
    }
    le := s.len
    for i := le - 3; i >= 1; i -= 3 {
        s = '${s[0..i]},${s[i..]}'
    }
    if n >= 0 {
        return s
    }
    return "-$s"
}

fn main() {
    start := time.now()
    for n := 1; n <= 100000; n *= 10 {
        mut s := "th"
        if n == 1 {
            s = "st"
        }
        println("The ${commatize(n)}$s Ulam number is ${commatize(ulam(n))}")
    }
    println("\nTook ${time.since(start)}")
}
