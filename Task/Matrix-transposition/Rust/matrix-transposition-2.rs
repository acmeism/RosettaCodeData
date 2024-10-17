fn main() {
    let m = vec![vec![1, 2, 3], vec![4, 5, 6]];
    println!("Matrix:\n{}", matrix_to_string(&m));
    let t = matrix_transpose(m);
    println!("Transpose:\n{}", matrix_to_string(&t));
}

fn matrix_to_string(m: &Vec<Vec<i32>>) -> String {
    m.iter().fold("".to_string(), |a, r| {
        a + &r
            .iter()
            .fold("".to_string(), |b, e| b + "\t" + &e.to_string())
            + "\n"
    })
}

fn matrix_transpose(m: Vec<Vec<i32>>) -> Vec<Vec<i32>> {
    let mut t = vec![Vec::with_capacity(m.len()); m[0].len()];
    for r in m {
        for i in 0..r.len() {
            t[i].push(r[i]);
        }
    }
    t
}
