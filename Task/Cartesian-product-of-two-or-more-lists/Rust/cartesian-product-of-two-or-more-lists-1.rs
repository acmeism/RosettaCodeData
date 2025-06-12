fn cartesian_product<'a, T>(lists: &[&'a [T]]) -> Vec<Vec<&'a T>> {
    let mut res = vec![vec![]];

    for &list in lists {
        let mut tmp = Vec::new();

        for r in res {
            for item in list {
                let mut r = r.clone();
                r.push(item);
                tmp.push(r);
            }
        }

        res = tmp;
    }

    res
}

fn main() {
    let cases: [&[&[u32]]; 7] = [
        &[&[1, 2], &[3, 4]],
        &[&[3, 4], &[1, 2]],
        &[&[1, 2], &[]],
        &[&[], &[1, 2]],
        &[&[1776, 1789], &[7, 12], &[4, 14, 23], &[0, 1]],
        &[&[1, 2, 3], &[30], &[500, 100]],
        &[&[1, 2, 3], &[], &[500, 100]],
    ];

    for case in cases {
        println!(
            "{}\n{:?}\n",
            case.iter()
                .map(|c| format!("{:?}", c))
                .collect::<Vec<_>>()
                .join(" × "),
            cartesian_product(case)
        )
    }
}
