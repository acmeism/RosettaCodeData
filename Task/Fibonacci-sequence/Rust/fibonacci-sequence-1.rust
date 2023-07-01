fn main() {
    let mut prev = 0;
    // Rust needs this type hint for the checked_add method
    let mut curr = 1usize;

    while let Some(n) = curr.checked_add(prev) {
        prev = curr;
        curr = n;
        println!("{}", n);
    }
}
