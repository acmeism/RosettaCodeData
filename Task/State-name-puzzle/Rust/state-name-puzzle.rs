use std::collections::HashMap;

fn solve(states: Vec<&str>) {
    let mut dict = HashMap::new();
    for state in states {
        let key = state.to_lowercase().replace(" ", "");
        if !dict.contains_key(&key) {
            dict.insert(key, state);
        }
    }
    let keys: Vec<&String> = dict.keys().collect();
    let mut solutions: Vec<String> = vec![];
    let mut duplicates: Vec<String> = vec![];
    for i in 0..keys.len() {
        for j in i + 1..keys.len() {
            let len = keys[i].len() + keys[j].len();
            let mut chars: Vec<char> = (String::new() + keys[i] + keys[j]).chars().collect();
            chars.sort();
            let combined: String = chars.into_iter().collect();
            for k in 0..keys.len() {
                for m in k + 1..keys.len() {
                    if k == i || k == j || m == i || m == j {
                        continue;
                    }
                    let len2 = keys[k].len() + keys[m].len();
                    if len2 != len {
                        continue;
                    }
                    let mut chars2 = (String::new() + keys[k] + keys[m])
                        .chars()
                        .collect::<Vec<char>>();
                    chars2.sort();
                    let combined2: String = chars2.into_iter().collect();
                    if combined == combined2 {
                        let f1 = format!("{} + {}", dict[keys[i]], dict[keys[j]]);
                        let f2 = format!("{} + {}", dict[keys[k]], dict[keys[m]]);
                        let f3 = format!("{f1} = {f2}");
                        if duplicates.contains(&f3) {
                            continue;
                        }
                        solutions.push(f3);
                        let f4 = format!("{f2} = {f1}");
                        duplicates.push(f4);
                    }
                }
            }
        }
    }
    solutions.sort();
    for (i, sol) in solutions.iter().enumerate() {
        println!("{:>2}  {}", i + 1, sol);
    }
}

fn main() {
    let mut states = [
        "Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut",
        "Delaware", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa",
        "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts", "Michigan",
        "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada",
        "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina",
        "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island",
        "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont",
         "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming",].to_vec();
    println!("Real states only:");
    solve(states.clone());
    let mut fictitious = ["New Kory", "Wen Kory", "York New", "Kory New", "New Kory"].to_vec();
    println!("\nReal and fictitious states:");
    states.append(&mut fictitious);
    solve(states.clone());
}
