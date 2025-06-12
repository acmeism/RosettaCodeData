use itertools::{Itertools, MultiProduct};

fn cartesian_product<'a, T>(inputs: &[&'a [T]]) -> MultiProduct<core::slice::Iter<'a, T>> {
    inputs
        .iter()
        .map(|slice| slice.iter())
        .multi_cartesian_product()
}

fn main() {
    let cases: [&[&[u32]]; 7] = [
        &[&[1, 2], &[3, 4]],
        &[&[3, 4], &[1, 2]],
        &[&[1, 2], &[]],
        &[&[], &[1, 2]],
        &[&[1776, 1789], &[7, 12], &[4, 14, 23], &[0, 1]],
        &[&[1, 2, 3], &[30], &[500, 100]],
        &[&[1, 2, 3], &[], &[500, 1000]],
    ];

    for case in cases {
        println!(
            "{:?}\n[{:?}]\n",
            case.iter().format(" × "),
            cartesian_product(case).format(", ")
        );
    }
}
