fn only_consecutive_in(a: &[i32], lis: &[i32]) -> bool {
    return (0..lis.len() - a.len() + 1).any(|i| a == &lis[i..i + a.len()])
        && (0..a.len()).all(|i| {
            lis.iter().filter(|x| **x == a[i]).count() == a.iter().filter(|x| **x == a[i]).count()
        });
}

fn main() {
    let needles = [[3, 3, 3], [3, 2, 3]];
    let pair_of_haystacks = [
        [
            [9, 3, 3, 3, 2, 1, 7, 8, 5],
            [5, 2, 9, 3, 3, 7, 8, 4, 1],
            [1, 4, 3, 3, 3, 3, 8, 3, 2],
            [1, 2, 3, 4, 5, 6, 7, 8, 9],
            [4, 6, 8, 7, 2, 3, 3, 3, 1],
        ],
        [
            [9, 3, 3, 3, 2, 3, 7, 8, 5],
            [5, 6, 9, 1, 3, 2, 3, 4, 1],
            [1, 4, 3, 6, 7, 3, 8, 3, 2],
            [1, 2, 3, 4, 5, 6, 7, 8, 9],
            [4, 6, 8, 7, 2, 3, 2, 3, 1],
        ],
    ];

    for idx in [0_usize, 1] {
        let (haystacks, needle) = (pair_of_haystacks[idx], needles[idx]);
        for haystack in haystacks {
            println!(
                "{:?} in {:?}: {:?}",
                needle,
                haystack,
                only_consecutive_in(&needle, &haystack)
            );
        }
    }

    let haystacks = [
        [9, 3, 3, 3, 2, 1, 7, 8, 5],
        [5, 2, 9, 3, 3, 7, 8, 4, 1],
        [1, 4, 3, 6, 7, 3, 8, 3, 2],
        [1, 2, 3, 4, 5, 6, 7, 8, 9],
        [4, 6, 8, 7, 2, 3, 3, 3, 1],
        [3, 3, 3, 1, 2, 4, 5, 1, 3],
        [0, 3, 3, 3, 3, 7, 2, 2, 6],
        [3, 3, 3, 3, 3, 4, 4, 4, 4],
    ];

    for i in 1_i32..=4 {
        let needle = vec![i; i as usize];
        for haystack in haystacks {
            println!(
                "{:?} in {:?}: {:?}",
                needle,
                haystack,
                only_consecutive_in(&needle.as_slice(), &haystack)
            );
        }
    }
}
