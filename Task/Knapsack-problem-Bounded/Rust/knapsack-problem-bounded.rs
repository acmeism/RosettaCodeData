use std::collections::HashMap;

fn main() {
    let max_wt = 400;

    let grouped_items = vec![
        ("map", 9, 150, 1),
        ("compass", 13, 35, 1),
        ("water", 153, 200, 3),
        ("sandwich", 50, 60, 2),
        ("glucose", 15, 60, 2),
        ("tin", 68, 45, 3),
        ("banana", 27, 60, 3),
        ("apple", 39, 40, 3),
        ("cheese", 23, 30, 1),
        ("beer", 52, 10, 3),
        ("suntan cream", 11, 70, 1),
        ("camera", 32, 30, 1),
        ("t-shirt", 24, 15, 2),
        ("trousers", 48, 10, 2),
        ("umbrella", 73, 40, 1),
        ("waterproof trousers", 42, 70, 1),
        ("waterproof overclothes", 43, 75, 1),
        ("note-case", 22, 80, 1),
        ("sunglasses", 7, 20, 1),
        ("towel", 18, 12, 2),
        ("socks", 4, 50, 1),
        ("book", 30, 10, 2),
    ];

    let mut items = Vec::new();
    for &(item, wt, val, n) in &grouped_items {
        for _ in 0..n {
            items.push((item, wt, val));
        }
    }

    let bagged = knapsack01_dp(&items, max_wt);

    // Count and group the bagged items
    let mut counts: HashMap<&str, i32> = HashMap::new();
    for &(item, _, _) in &bagged {
        *counts.entry(item).or_insert(0) += 1;
    }

    // Sort and print the results
    let mut sorted_counts: Vec<_> = counts.iter().collect();
    sorted_counts.sort_by_key(|&(item, _)| *item);

    println!("Bagged the following {} items", bagged.len());
    for (item, count) in sorted_counts {
        println!("  {} off: {}", count, item);
    }

    let total_value: i32 = bagged.iter().map(|&(_, _, val)| val).sum();
    let total_weight: i32 = bagged.iter().map(|&(_, wt, _)| wt).sum();

    println!("for a total value of {} and a total weight of {}",
             total_value, total_weight);
}

fn knapsack01_dp<'a>(items: &'a [(&'a str, i32, i32)], limit: i32) -> Vec<(&'a str, i32, i32)> {
    let n = items.len();
    let limit_usize = limit as usize;

    // Create DP table
    let mut table = vec![vec![0; (limit_usize + 1) as usize]; n + 1];

    for j in 1..=n {
        let (_, wt, val) = items[j-1];
        let wt_usize = wt as usize;

        for w in 1..=limit_usize {
            if wt_usize > w {
                table[j][w] = table[j-1][w];
            } else {
                table[j][w] = std::cmp::max(
                    table[j-1][w],
                    table[j-1][w - wt_usize] + val
                );
            }
        }
    }

    // Backtrack to find items
    let mut result = Vec::new();
    let mut w = limit_usize;

    for j in (1..=n).rev() {
        let was_added = table[j][w] != table[j-1][w];

        if was_added {
            result.push(items[j-1]);
            w -= items[j-1].1 as usize;
        }
    }

    result
}
