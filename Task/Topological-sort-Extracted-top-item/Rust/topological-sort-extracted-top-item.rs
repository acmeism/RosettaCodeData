use std::collections::{HashMap, HashSet};

fn print_vector<T: std::fmt::Display>(vec: &Vec<T>) {
    print!("[");
    for i in 0..vec.len() - 1 {
        print!("{}, ", vec[i]);
    }
    println!("{}]", vec.last().unwrap());
}

fn print_set<T: std::fmt::Display>(a_set: &HashSet<T>) {
    let mut iter = a_set.iter();
    if let Some(first) = iter.next() {
        print!("{}", first);
        for item in iter {
            print!(", {}", item);
        }
    }
}

// Return the top levels of the dependency graph
fn top_levels(data: &HashMap<String, HashSet<String>>) -> HashSet<String> {
    // Remove self dependencies (mutable copy)
    let mut data_copy = data.clone();
    for (key, value) in data_copy.iter_mut() {
        value.remove(key);
    }

    let mut dependencies: Vec<String> = Vec::new();
    for (_key, value) in &data_copy {
        dependencies.extend(value.clone());
    }

    let mut result: HashSet<String> = data_copy.keys().cloned().collect();

    for dependency in &dependencies {
        result.remove(dependency);
    }
    result
}

// Return the set of top level items in topological order
fn top_extraction(
    mut data: HashMap<String, HashSet<String>>,
    mut tops: HashSet<String>,
) -> Vec<Vec<String>> {
    // Remove self dependencies
    for (key, value) in data.iter_mut() {
        value.remove(key);
    }

    let mut dependencies: HashSet<String> = HashSet::new();
    let mut cumulative_dependencies: Vec<HashSet<String>> = Vec::new();

    loop {
        cumulative_dependencies.push(tops.clone());

        dependencies.clear();
        for element in &tops {
            if data.contains_key(element) {
                if let Some(deps) = data.get(element) {
                    dependencies.extend(deps.clone());
                }
            }
        }
        tops = dependencies.clone();
        if dependencies.is_empty() {
            break;
        }
    }

    let mut result: Vec<Vec<String>> = Vec::new();
    let mut accumulator: HashSet<String> = HashSet::new();
    for i in (0..cumulative_dependencies.len()).rev() {
        let mut current_dependencies = cumulative_dependencies[i].clone();
        for accum in &accumulator {
            current_dependencies.remove(accum);
        }

        let mut current_dependencies_vec: Vec<String> =
            current_dependencies.into_iter().collect();
        current_dependencies_vec.sort();

        result.push(current_dependencies_vec);
        accumulator.extend(cumulative_dependencies[i].clone());
    }

    result
}

fn print_compilation_order(order: &Vec<Vec<String>>) {
    if !order.is_empty() {
        print!("First: ");
        print_vector(&order[0]);
    }
    for i in 1..order.len() {
        print!("    Then: ");
        print_vector(&order[i]);
    }
    println!();
}

fn main() {
    let data: HashMap<String, HashSet<String>> = [
        (
            "top1".to_string(),
            ["ip1", "des1", "ip2"].iter().map(|s| s.to_string()).collect(),
        ),
        (
            "top2".to_string(),
            ["ip2", "des1", "ip3"].iter().map(|s| s.to_string()).collect(),
        ),
        (
            "des1".to_string(),
            ["des1a", "des1b", "des1c"]
                .iter()
                .map(|s| s.to_string())
                .collect(),
        ),
        (
            "des1a".to_string(),
            ["des1a1", "des1a2"]
                .iter()
                .map(|s| s.to_string())
                .collect(),
        ),
        (
            "des1c".to_string(),
            ["des1c1", "extra1"].iter().map(|s| s.to_string()).collect(),
        ),
        (
            "ip2".to_string(),
            ["ip2a", "ip2b", "ip2c", "ipcommon"]
                .iter()
                .map(|s| s.to_string())
                .collect(),
        ),
        (
            "ip1".to_string(),
            ["ip1a", "ipcommon", "extra1"]
                .iter()
                .map(|s| s.to_string())
                .collect(),
        ),
    ]
    .iter()
    .cloned()
    .collect();

    let tops = top_levels(&data);
    print!("The top levels of the dependency graph are: ");
    print_set(&tops);
    println!("\n");

    for top in &tops {
        println!("The compilation order for top level '{}' is:", top);
        print_compilation_order(&top_extraction(data.clone(), [top.clone()].iter().cloned().collect()));
    }

    if tops.len() > 1 {
        print!("The compilation order for top levels '");
        print_set(&tops);
        println!("' is:");
        print_compilation_order(&top_extraction(data.clone(), tops.clone()));
    }

    let ip1 = "ip1".to_string();
    println!("The compilation order for file '{}' is:", ip1);
    print_compilation_order(&top_extraction(data.clone(), [ip1].iter().cloned().collect()));
}
