import os

fn main() {
    mut prev, mut next := f64(0), f64(0)
    mut count := 1
    for prev < 1 {
       prev = os.input_opt("Enter a number: ") or {panic(err)}.f64()
    }
    for {
        println("${next}")
        next = (prev + 3) * 0.86
        if prev == next {break}
        prev = next
        count++
    }
    print("Took ${count} iterations.")
}
