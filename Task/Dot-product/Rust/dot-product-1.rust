// alternatively, fn dot_product(a: &Vec<u32>, b: &Vec<u32>)
// but using slices is more general and rustic
fn dot_product(a: &[i32], b: &[i32]) -> Option<i32> {
    if a.len() != b.len() { return None }
    Some(
        a.iter()
            .zip( b.iter() )
            .fold(0, |sum, (el_a, el_b)| sum + el_a*el_b)
    )
}


fn main() {
    let v1 = vec![1, 3, -5];
    let v2 = vec![4, -2, -1];

    println!("{}", dot_product(&v1, &v2).unwrap());
}
