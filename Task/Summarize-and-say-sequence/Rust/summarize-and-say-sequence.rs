use itertools::Itertools;
use std::collections::HashSet;

fn n_to_v(n: &i32) -> Vec<i32> {
    return n
        .to_string()
        .as_bytes()
        .iter()
        .map(|c| *c as i32 - '0' as i32)
        .collect_vec();
}

fn v_to_s(v: &Vec<i32>) -> String {
    return v
        .iter()
        .map(|i| {
            assert!(*i < 10 && *i >= 0);
            i.to_string()
        })
        .join("");
}

fn v_to_n(v: &Vec<i32>) -> i32 {
    let mut r = v.to_vec();
    r.reverse();
    return r.iter().fold(0, |sum, i| sum * 10 + i);
}

fn generate_next_term(digits: Vec<i32>) -> Vec<i32> {
    let mut counts = vec![0; 10];
    let mut next: Vec<i32> = vec![];
    for i in digits {
        assert!(i < 10);
        counts[i as usize] += 1;
    }
    for i in [9, 8, 7, 6, 5, 4, 3, 2, 1, 0] {
        if counts[i as usize] > 0 {
            for d in n_to_v(&counts[i as usize]) {
                next.push(d);
            }
            next.push(i);
        }
    }
    return next;
}

fn generate_sequence(seedterm: &Vec<i32>) -> (usize, Vec<Vec<i32>>, usize) {
    let mut seen = HashSet::new();
    let mut term_vec = seedterm.clone();
    let mut term_string = v_to_s(&term_vec);
    let mut sequence: Vec<Vec<i32>> = vec![];
    for iterations in 0..1000 {
        sequence.push(term_vec.to_vec());
        if !seen.contains(&term_string) {
            seen.insert(term_string.clone());
            term_vec = generate_next_term(term_vec);
            term_string = v_to_s(&term_vec);
        } else {
            // found a repeat in the sequence, so find where last one was
            let prev = (0..sequence.len())
                .find(|i| sequence[*i] == term_vec)
                .unwrap();
            return (iterations, sequence, prev);
        }
    }
    panic!("Could not find a repeat in sequence within 1000 iterations")
}

// To decrease memory usage, just save the seeds and recalculate sequence later
// To speed up loop, just calculate the numbers with presorted digit sequences
// and then use permutations of results to regenerate the skipped seeds
fn find_max_sequences(start: i32, stop: i32) {
    let mut max_length = 1_usize;
    let mut max_length_seeds: Vec<i32> = vec![];
    for i in start..=stop {
        let v = n_to_v(&i);
        let mut dup_seq = v.to_vec();
        dup_seq.sort();
        dup_seq.reverse();
        if v != dup_seq {
            continue;
        }
        let (seq_len, _seq, _prev) = generate_sequence(&v);
        if seq_len > max_length {
            max_length_seeds.clear();
            max_length_seeds.push(i);
            max_length = seq_len;
        } else if seq_len == max_length {
            max_length_seeds.push(i);
        }
    }
    let mut perm_seeds: Vec<i32> = vec![];
    for seed in max_length_seeds.clone() {
        let v = n_to_v(&seed);
        let minresult = 10_i32.pow(v.len() as u32 - 1_u32);
        for p in v.iter().permutations(v.len()) {
            let perm = p.iter().map(|x| **x).collect_vec();
            let n = v_to_n(&perm);
            if n >= minresult {
                perm_seeds.push(v_to_n(&perm));
            }
        }
    }
    perm_seeds.sort();
    perm_seeds.dedup();
    println!(
        "Seeds:    {}",
        perm_seeds.iter().map(|n| n.to_string()).join("  ")
    );
    println!("\n Iterations: {max_length}\n\nExample sequence:\n");
    let (_len, seq, prev) = generate_sequence(&n_to_v(&max_length_seeds[0]));
    for (idx, v) in seq.iter().enumerate() {
        println!(
            "{:<2}:  {}{}",
            idx + 1,
            v.iter().map(|i| i.to_string()).join(""),
            if idx == seq.len() - 1 {
                format!("  <-- repeats the sequence from line {}.", prev + 1)
            } else {
                "".to_string()
            },
        );
    }
}

fn main() {
    find_max_sequences(1, 999_999);
}
