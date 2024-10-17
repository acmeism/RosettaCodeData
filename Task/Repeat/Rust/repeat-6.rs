fn repeat(f: impl FnMut(usize), n: usize) {
    (0..n).for_each(f);
}

fn main() {
    let mut mult = 1;
    repeat(|x| {
        print!("{};", x * mult);
        mult += x;
    }, 5);
}
