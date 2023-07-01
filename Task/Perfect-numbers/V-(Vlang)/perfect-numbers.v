fn compute_perfect(n i64) bool {
    mut sum := i64(0)
    for i := i64(1); i < n; i++ {
        if n%i == 0 {
            sum += i
        }
    }
    return sum == n
}

// following fntion satisfies the task, returning true for all
// perfect numbers representable in the argument type
fn is_perfect(n i64) bool {
    return n in [i64(6), 28, 496, 8128, 33550336, 8589869056,
        137438691328, 2305843008139952128]
}

// validation
fn main() {
    for n := i64(1); ; n++ {
        if is_perfect(n) != compute_perfect(n) {
            panic("bug")
        }
        if n%i64(1e3) == 0 {
            println("tested $n")
        }
    }
}
