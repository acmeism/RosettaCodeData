import rand
import rand.seed
import math
// "given"
fn dice5() int {
    return rand.intn(5) or {0} + 1
}

// fntion specified by task "Seven-sided dice from five-sided dice"
fn dice7() int {
    mut i := 0
    for {
        i = 5*dice5() + dice5()
        if i < 27 {
            break
        }
    }
    return (i / 3) - 1
}

// fntion specified by task "Verify distribution uniformity/Naive"
//
// Parameter "f" is expected to return a random integer in the range 1..n.
// (Values out of range will cause an unceremonious crash.)
// "Max" is returned as an "indication of distribution achieved."
// It is the maximum delta observed from the count representing a perfectly
// uniform distribution.
// Also returned is a boolean, true if "max" is less than threshold
// parameter "delta."
fn dist_check(f fn() int, n int,
    repeats int, delta f64) (f64, bool) {
    mut max := 0.0
    mut count := []int{len: n}
    for _ in 0..repeats {
        count[f()-1]++
    }
    expected := f64(repeats) / f64(n)
    for c in count {
        max = math.max(max, math.abs(f64(c)-expected))
    }
    return max, max < delta
}

// Driver, produces output satisfying both tasks.
fn main() {
    rand.seed(seed.time_seed_array(2))
    calls := 1000000
    mut max, mut flat_enough := dist_check(dice7, 7, calls, 500)
    println("Max delta: $max Flat enough: $flat_enough")
    max, flat_enough = dist_check(dice7, 7, calls, 500)
    println("Max delta: $max Flat enough: $flat_enough")
}
