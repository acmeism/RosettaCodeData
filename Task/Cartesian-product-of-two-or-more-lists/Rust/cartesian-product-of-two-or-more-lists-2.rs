fn cartesian_product<T: Clone>(sets: &[Vec<T>]) -> Vec<Vec<T>> {
    if sets.is_empty() {
        return vec![vec![]];
    }

    let mut result = vec![vec![]];

    for set in sets {
        let mut temp = Vec::new();

        for res in &result {
            for item in set {
                let mut new_res = res.clone();
                new_res.push(item.clone());
                temp.push(new_res);
            }
        }

        result = temp;
    }

    result
}
