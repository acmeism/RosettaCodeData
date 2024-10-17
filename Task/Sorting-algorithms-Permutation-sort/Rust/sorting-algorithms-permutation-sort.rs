use itertools::Itertools;
use num::Num;

fn is_sorted<T>(data: &Vec<&T>) -> bool where T: Num + Ord {
    return data.windows(2).all(|pair| pair[0] <= pair[1]);
}

fn permsort<T>(arr: Vec<T>) -> Vec<T> where T: Num + Ord + Clone {
    for perm in arr.iter().permutations(arr.len()) {
        if is_sorted(&perm) {
            return perm.iter().cloned().cloned().collect();
        }
    }
    unreachable!("No ordered permutation found");
}

fn main() {
    let x = [4, 6, 5, 3, 1, 8, 7, 9, 10, 2].to_vec();
    println!("{:?}", permsort(x)); // [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
    return ();
}
