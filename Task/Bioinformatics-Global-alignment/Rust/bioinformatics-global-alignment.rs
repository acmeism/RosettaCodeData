use std::collections::{HashMap, HashSet};

// Print a report of the given string to the standard output device.
fn print_report(text: &str) {
    let mut bases: HashMap<char, i32> = HashMap::new();
    for ch in text.chars() {
        *bases.entry(ch).or_insert(0) += 1;
    }

    let total: i32 = bases.values().sum();

    println!("Nucleotide counts for: {}", if text.len() > 50 { "\n" } else { "" });
    println!("{}", text);
    println!("Bases: A {}, C: {}, G: {}, T: {}, total: {}\n",
             bases.get(&'A').unwrap_or(&0),
             bases.get(&'C').unwrap_or(&0),
             bases.get(&'G').unwrap_or(&0),
             bases.get(&'T').unwrap_or(&0),
             total);
}

// Return all permutations of the given list of strings.
fn permutations(list: &mut Vec<String>) -> Vec<Vec<String>> {
    let mut indexes: Vec<i32> = vec![0; list.len()];
    let mut result: Vec<Vec<String>> = Vec::new();
    result.push(list.clone());
    let mut i = 0;
    while i < list.len() {
        if indexes[i] < i as i32 {
            let j = if i % 2 == 0 { 0 } else { indexes[i] as usize };
            list.swap(i, j);
            result.push(list.clone());
            indexes[i] += 1;
            i = 0;
        } else {
            indexes[i] = 0;
            i += 1;
        }
    }
    result
}

// Return 'before' concatenated with 'after', removing the longest suffix of 'before' that matches a prefix of 'after'.
fn concatenate(before: &str, after: &str) -> String {
    for i in 0..before.len() {
        let suffix = &before[i..];
        if after.starts_with(suffix) {
            return format!("{}{}", &before[0..i], after);
        }
    }
    format!("{}{}", before, after)
}

// Remove duplicate strings and strings which are substrings of other strings in the given list.
fn deduplicate(list: &[String]) -> Vec<String> {
    let mut singletons = list.to_vec();
    singletons.sort();
    singletons.dedup();

    let result = singletons.clone();
    let mut marked_for_removal: HashSet<String> = HashSet::new();

    for test_word in &result {
        for word in &singletons {
            if word != test_word && word.contains(test_word) {
                marked_for_removal.insert(test_word.clone());
            }
        }
    }

    result.into_iter().filter(|word| !marked_for_removal.contains(word)).collect()
}

// Return a set containing all of the shortest common superstrings of the given list of strings.
fn shortest_common_superstrings(list: &[String]) -> HashSet<String> {
    let deduplicated = deduplicate(list);
    let mut deduplicated_mut = deduplicated.clone();

    let mut shortest: HashSet<String> = HashSet::new();
    let mut joined = String::new();
    for word in list {
        joined.push_str(word);
    }
    shortest.insert(joined);

    let mut shortest_length = list.iter().map(|s| s.len()).sum();

    for permutation in permutations(&mut deduplicated_mut) {
        let mut candidate = String::new();
        for word in permutation {
            candidate = concatenate(&candidate, &word);
        }

        if candidate.len() < shortest_length {
            shortest.clear();
            shortest_length = candidate.len();
            shortest.insert(candidate);
        } else if candidate.len() == shortest_length {
            shortest.insert(candidate);
        }
    }
    shortest
}

fn main() {
    let test_sequences: Vec<Vec<String>> = vec![
        vec!["TA".to_string(), "AAG".to_string(), "TA".to_string(), "GAA".to_string(), "TA".to_string()],
        vec!["CATTAGGG".to_string(), "ATTAG".to_string(), "GGG".to_string(), "TA".to_string()],
        vec!["AAGAUGGA".to_string(), "GGAGCGCAUC".to_string(), "AUCGCAAUAAGGA".to_string()],
        vec![
            "ATGAAATGGATGTTCTGAGTTGGTCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTAT".to_string(),
            "GGTCGATTCTGAGGACAAAGGTCAAGATGGAGCGCATCGAACGCAATAAGGATCATTTGATGGGACGTTTCGTCGACAAAGT".to_string(),
            "CTATGTTCTTATGAAATGGATGTTCTGAGTTGGTCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTATA".to_string(),
            "TGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTGAGGACAAAGGTCAAGATGGAGCGCATC".to_string(),
            "AACGCAATAAGGATCATTTGATGGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTT".to_string(),
            "GCGCATCGAACGCAATAAGGATCATTTGATGGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTC".to_string(),
            "CGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTTCGATTCTGCTTATAACACTATGTTCT".to_string(),
            "TGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTGAGGACAAAGGTCAAGATGGAGCGCATC".to_string(),
            "CGTAAAAAATTACAACGTCCTTTGGCTATCTCTTAAACTCCTGCTAAATGCTCGTGC".to_string(),
            "GATGGAGCGCATCGAACGCAATAAGGATCATTTGATGGGACGTTTCGTCGACAAAGTCTTGTTTCGAGAGTAACGGCTACCGTCTTCGATT".to_string(),
            "TTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTGAGGACAAAGGTCAAGATGGAGCGCATC".to_string(),
            "CTATGTTCTTATGAAATGGATGTTCTGAGTTGGTCAGTCCCAATGTGCGGGGTTTCTTTTAGTACGTCGGGAGTGGTATTATA".to_string(),
            "TCTCTTAAACTCCTGCTAAATGCTCGTGCTTTCCAATTATGTAAGCGTTCCGAGACGGGGTGGTCGATTCTGAGGACAAAGGTCAAGA".to_string(),
        ],
    ];

    for test in test_sequences {
        for superstring in shortest_common_superstrings(&test) {
            print_report(&superstring);
        }
    }
}
