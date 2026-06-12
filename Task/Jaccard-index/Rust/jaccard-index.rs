use std::collections::HashSet;
use std::fmt::Display;

fn vector_to_string<T: Display>(vec: &[T]) -> String {
    let mut result = String::from("[");
    for (i, item) in vec.iter().enumerate() {
        result.push_str(&item.to_string());
        if i < vec.len() - 1 {
            result.push_str(", ");
        }
    }
    result.push(']');
    result
}

fn jaccard_index(a: &[i32], b: &[i32]) -> f64 {
    let set_a: HashSet<i32> = a.iter().cloned().collect();

    let intersection_count = b.iter()
        .filter(|&element| set_a.contains(element))
        .count();

    let mut union_set = set_a.clone();
    union_set.extend(b.iter().cloned());
    let union_count = union_set.len();

    if union_count == 0 {
        1.0
    } else if intersection_count == 0 {
        0.0
    } else {
        intersection_count as f64 / union_count as f64
    }
}

fn main() {
    let tests: Vec<Vec<i32>> = vec![
        vec![],
        vec![1, 2, 3, 4, 5],
        vec![1, 3, 5, 7, 9],
        vec![2, 4, 6, 8, 10],
        vec![2, 3, 5, 7],
        vec![8],
    ];

    println!("     Set A              Set B         J(A, B)");
    println!("---------------------------------------------");

    for a in &tests {
        for b in &tests {
            println!("{:<19} {:<19} {:.5}",
                vector_to_string(a),
                vector_to_string(b),
                jaccard_index(a, b)
            );
        }
    }
}
