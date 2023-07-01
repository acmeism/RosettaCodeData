fn main() {
    s := [1, 2, 2, 3, 4, 4, 5]

    // There is no output as 'prev' is created anew each time
    // around the loop and set implicitly to zero.
    for i := 0; i < s.len; i++ {
        curr := s[i]
        mut prev := 0
        if i > 0 && curr == prev {
            println(i)
        }
        prev = curr
    }

    // Now 'prev' is created only once and reassigned
    // each time around the loop producing the desired output.
    mut prev := 0
    for i := 0; i < s.len; i++ {
        curr := s[i]
        if i > 0 && curr == prev {
            println(i)
        }
        prev = curr
    }
}
