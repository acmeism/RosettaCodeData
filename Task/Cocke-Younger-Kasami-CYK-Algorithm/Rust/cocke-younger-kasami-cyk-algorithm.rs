use std::collections::{HashMap, HashSet};

// Function to perform the CYK Algorithm
fn cyk_parse(w: &[&str], r: &HashMap<&str, Vec<Vec<&str>>>) {
    let n = w.len();

    // Initialize the table with empty sets
    let mut t: Vec<Vec<HashSet<&str>>> = vec![vec![HashSet::new(); n]; n];

    // Filling in the table
    for j in 0..n {

        // Iterate over the rules
        for (lhs, rules) in r.iter() {
            for rhs in rules {

                // If a terminal is found
                if rhs.len() == 1 && rhs[0] == w[j] {
                    t[j][j].insert(lhs);
                }
            }
        }

        for i in (0..=j).rev() {

            // Iterate over the range i to j
            for k in i..j {

                // Iterate over the rules
                for (lhs, rules) in r.iter() {
                    for rhs in rules {

                        // If a non-terminal pair is found
                        if rhs.len() == 2 &&
                           t[i][k].contains(rhs[0]) &&
                           t[k + 1][j].contains(rhs[1]) {
                            t[i][j].insert(lhs);
                        }
                    }
                }
            }
        }
    }

    // If word can be formed by rules of given grammar
    if t[0][n - 1].contains("NP") {
        println!("True");
    } else {
        println!("False");
    }
}

fn main() {
    // Non-terminal symbols
    let _non_terminals = vec!["NP", "Nom", "Det", "AP", "Adv", "A"];
    let _terminals = vec!["book", "orange", "man", "tall", "heavy", "very", "muscular"];

    // Rules of the grammar
    let mut r: HashMap<&str, Vec<Vec<&str>>> = HashMap::new();
    r.insert("NP", vec![vec!["Det", "Nom"]]);
    r.insert("Nom", vec![
        vec!["AP", "Nom"],
        vec!["book"],
        vec!["orange"],
        vec!["man"]
    ]);
    r.insert("AP", vec![
        vec!["Adv", "A"],
        vec!["heavy"],
        vec!["orange"],
        vec!["tall"]
    ]);
    r.insert("Det", vec![vec!["a"]]);
    r.insert("Adv", vec![vec!["very"], vec!["extremely"]]);
    r.insert("A", vec![
        vec!["heavy"],
        vec!["orange"],
        vec!["tall"],
        vec!["muscular"]
    ]);

    // Given string
    let w: Vec<&str> = "a very heavy orange book".split_whitespace().collect();

    // Function Call
    cyk_parse(&w, &r);
}
