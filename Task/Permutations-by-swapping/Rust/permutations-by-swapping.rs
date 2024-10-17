// Implementation of Heap's algorithm.
// See https://en.wikipedia.org/wiki/Heap%27s_algorithm#Details_of_the_algorithm
fn generate<T, F>(a: &mut [T], output: F)
where
    F: Fn(&[T], isize),
{
    let n = a.len();
    let mut c = vec![0; n];
    let mut i = 1;
    let mut sign = 1;
    output(a, sign);
    while i < n {
        if c[i] < i {
            if (i & 1) == 0 {
                a.swap(0, i);
            } else {
                a.swap(c[i], i);
            }
            sign = -sign;
            output(a, sign);
            c[i] += 1;
            i = 1;
        } else {
            c[i] = 0;
            i += 1;
        }
    }
}

fn print_permutation<T: std::fmt::Debug>(a: &[T], sign: isize) {
    println!("{:?} {}", a, sign);
}

fn main() {
    println!("Permutations and signs for three items:");
    let mut a = vec![0, 1, 2];
    generate(&mut a, print_permutation);

    println!("\nPermutations and signs for four items:");
    let mut b = vec![0, 1, 2, 3];
    generate(&mut b, print_permutation);
}
