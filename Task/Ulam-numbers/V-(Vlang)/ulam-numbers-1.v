import time
fn ulam(n int) int {
    mut ulams := [1, 2]
    mut set := {1: true, 2: true}
    mut i := 3
    for {
        mut count := 0
        for j := 0; j < ulams.len; j++ {
            ok := set[i-ulams[j]]
            if ok && ulams[j] != (i-ulams[j]) {
                count++
                if count > 2 {
                    break
                }
            }
        }
        if count == 2 {
            ulams << i
            set[i] = true
            if ulams.len == n {
                break
            }
        }
        i++
    }
    return ulams[n-1]
}

fn main() {
    start := time.now()
    for n := 10; n <= 10000; n *= 10 {
        println("The ${n}th Ulam number is ${ulam(n)}")
    }
    println("\nTook ${time.since(start)}")
}
