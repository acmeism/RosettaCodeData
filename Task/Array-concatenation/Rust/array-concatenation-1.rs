fn main() {
    let a_vec = vec![1, 2, 3, 4, 5];
    let b_vec = vec![6; 5];

    let c_vec = concatenate_arrays(&a_vec, &b_vec);

    println!("{:?} ~ {:?} => {:?}", a_vec, b_vec, c_vec);
}

fn concatenate_arrays<T: Clone>(x: &[T], y: &[T]) -> Vec<T> {
    let mut concat = x.to_vec();
    concat.extend_from_slice(y);

    concat
}
