fn main() {
    let mut v = vec![1, 2, 3, 4, 5, 6, 7, 8, 9];
    println!("Before: {:?}", v);
    v.rotate_left(3);
    println!(" After: {:?}", v);
}
