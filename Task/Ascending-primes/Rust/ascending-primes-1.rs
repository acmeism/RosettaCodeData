/// Call depth-first recursive function to generate increasing sizes of powerset integers whose
/// digits are strictly increasing.
///
/// We then apply a primality test to each number (512 primality tests in total)
fn powerset_from_recursion() -> Vec<u32> {
    let ps = powerset(123456789);

    ps.into_iter().filter(|n| is_prime(*n)).collect()
}

/// Depth-first powerset integers generated through passed-in digits in base-10
///
/// Each returning `powerset` doubles its size, incorporating a new digit through each pass
///
/// Ex: `rem = 3` and our `powerset = [0, 1, 2, 12]`
///
/// `3` is "pushed back" to each value
///
/// `[03, 13, 23, 123]`
///
/// Which is then appended to the back of the original `powerset`
fn powerset(digits: u32) -> Vec<u32> {
    let (rem, quo) = (digits % 10, digits / 10);

    // Base case
    if rem == 0 {
        // Having 0 allows adding `rem` as single digit to `new`
        return vec![0];
    }

    let mut powerset = powerset(quo);
    let new = powerset.clone().into_iter().map(|n| n * 10 + rem);
    powerset.extend(new);

    powerset
}
