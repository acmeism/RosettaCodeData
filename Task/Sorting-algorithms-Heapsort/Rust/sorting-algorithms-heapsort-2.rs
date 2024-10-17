use std::collections::BinaryHeap;

fn main() {
    let src = vec![6, 2, 3, 6, 1, 2, 7, 8, 3, 2];
    let sorted = BinaryHeap::from(src).into_sorted_vec();
    println!("{:?}", sorted);
}
