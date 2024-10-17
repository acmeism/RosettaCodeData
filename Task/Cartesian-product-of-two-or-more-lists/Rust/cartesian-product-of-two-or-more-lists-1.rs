fn cartesian_product(lists: &Vec<Vec<u32>>) -> Vec<Vec<u32>> {
    let mut res = vec![];

    let mut list_iter = lists.iter();
    if let Some(first_list) = list_iter.next() {
        for &i in first_list {
            res.push(vec![i]);
        }
    }
    for l in list_iter {
        let mut tmp = vec![];
        for r in res {
            for &el in l {
                let mut tmp_el = r.clone();
                tmp_el.push(el);
                tmp.push(tmp_el);
            }
        }
        res = tmp;
    }
    res
}

fn main() {
    let cases = vec![
        vec![vec![1, 2], vec![3, 4]],
        vec![vec![3, 4], vec![1, 2]],
        vec![vec![1, 2], vec![]],
        vec![vec![], vec![1, 2]],
        vec![vec![1776, 1789], vec![7, 12], vec![4, 14, 23], vec![0, 1]],
        vec![vec![1, 2, 3], vec![30], vec![500, 100]],
        vec![vec![1, 2, 3], vec![], vec![500, 100]],
    ];
    for case in cases {
        println!(
            "{}\n{:?}\n",
            case.iter().map(|c| format!("{:?}", c)).collect::<Vec<_>>().join(" × "),
            cartesian_product(&case)
        )
    }
}
