use std::collections::HashMap;

fn main() {
    println!("{}\n", mcm_display(vec![5, 6, 3, 1]));
    println!(
        "{}\n",
        mcm_display(vec![1, 5, 25, 30, 100, 70, 2, 1, 100, 250, 1, 1000, 2])
    );
    println!(
        "{}\n",
        mcm_display(vec![1000, 1, 500, 12, 1, 700, 2500, 3, 2, 5, 14, 10])
    );
}

fn mcm_display(dims: Vec<i32>) -> String {
    let mut costs: HashMap<Vec<i32>, (i32, Vec<usize>)> = HashMap::new();
    let mut line = format!("Dims : {:?}\n", dims);
    let ans = mcm(dims, &mut costs);
    let mut mats = (1..=ans.1.len() + 1)
        .map(|x| x.to_string())
        .collect::<Vec<String>>();
    for i in 0..ans.1.len() {
        let mat_taken = mats[ans.1[i]].clone();
        mats.remove(ans.1[i]);
        mats[ans.1[i]] = "(".to_string() + &mat_taken + "*" + &mats[ans.1[i]] + ")";
    }
    line += &format!("Order: {}\n", mats[0]);
    line += &format!("Cost : {}", ans.0);
    line
}

fn mcm(dims: Vec<i32>, costs: &mut HashMap<Vec<i32>, (i32, Vec<usize>)>) -> (i32, Vec<usize>) {
    match costs.get(&dims) {
        Some(c) => c.clone(),
        None => {
            let ans = if dims.len() == 3 {
                (dims[0] * dims[1] * dims[2], vec![0])
            } else {
                let mut min_cost = std::i32::MAX;
                let mut min_path = Vec::new();
                for i in 1..dims.len() - 1 {
                    let taken = dims[(i - 1)..(i + 2)].to_vec();
                    let mut rest = dims[..i].to_vec();
                    rest.extend_from_slice(&dims[(i + 1)..]);
                    let a1 = mcm(taken, costs);
                    let a2 = mcm(rest, costs);
                    if a1.0 + a2.0 < min_cost {
                        min_cost = a1.0 + a2.0;
                        min_path = vec![i - 1];
                        min_path.extend_from_slice(&a2.1);
                    }
                }
                (min_cost, min_path)
            };
            costs.insert(dims, ans.clone());
            ans
        }
    }
}
