fn next_permutation<T: PartialOrd>(array: &mut [T]) -> bool {
    let len = array.len();
    if len < 2 {
        return false;
    }
    let mut i = len - 1;
    while i > 0 {
        let j = i;
        i -= 1;
        if array[i] < array[j] {
            let mut k = len - 1;
            while array[i] >= array[k] {
                k -= 1;
            }
            array.swap(i, k);
            array[j..len].reverse();
            return true;
        }
    }
    false
}

fn next_highest_int(n: u128) -> u128 {
    use std::iter::FromIterator;
    let mut chars: Vec<char> = n.to_string().chars().collect();
    if !next_permutation(&mut chars) {
        return 0;
    }
    String::from_iter(chars).parse::<u128>().unwrap()
}

fn main() {
    for n in &[0, 9, 12, 21, 12453, 738440, 45072010, 95322020, 9589776899767587796600] {
        println!("{} -> {}", n, next_highest_int(*n));
    }
}
