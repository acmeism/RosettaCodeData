use std::u64;

#[allow(non_snake_case)]
fn held_karp(dist: &[Vec<u64>]) -> (u64, Vec<usize>) {
    let n = dist.len();
    assert!(n > 1 && n <= (std::mem::size_of::<usize>() * 8));
    let N = 1 << n;
    let inf = u64::MAX / 4;

    // dp[mask][j] = min cost to start at 0, visit exactly the cities in mask, and end at j
    let mut dp = vec![vec![inf; n]; N];
    // parent[mask][j] = previous city before j in optimal path covering mask
    let mut parent = vec![vec![None; n]; N];

    // Base case: at city 0 with mask = 1<<0
    dp[1][0] = 0;

    // Build up dp
    for mask in 1..N {
        if mask & 1 == 0 {
            // we always include city 0 in the tour
            continue;
        }
        for j in 1..n {
            if mask & (1 << j) == 0 {
                continue; // city j not in this subset
            }
            let prev_mask = mask ^ (1 << j);
            // try to come to j from some k in prev_mask
            for k in 0..n {
                if prev_mask & (1 << k) == 0 {
                    continue;
                }
                let cost = dp[prev_mask][k].saturating_add(dist[k][j]);
                if cost < dp[mask][j] {
                    dp[mask][j] = cost;
                    parent[mask][j] = Some(k);
                }
            }
        }
    }

    // Close the tour by returning to city 0
    let full_mask = N - 1;
    let mut min_cost = inf;
    let mut last_city = 0;
    for j in 1..n {
        let cost = dp[full_mask][j].saturating_add(dist[j][0]);
        if cost < min_cost {
            min_cost = cost;
            last_city = j;
        }
    }

    // Reconstruct the tour path
    let mut path = Vec::with_capacity(n + 1);
    let mut mask = full_mask;
    let mut curr = last_city;
    // backtrack until we reach city 0
    while curr != 0 {
        path.push(curr);
        let prev = parent[mask][curr]
            .expect("Parent must exist for all but the start city");
        mask ^= 1 << curr;
        curr = prev;
    }
    path.push(0);       // include the start city
    path.reverse();     // now path = [0, ..., last_city]
    path.push(0);       // return to start

    (min_cost, path)
}

fn main() {
    // Example test case: 4 cities, symmetric distances
    let dist: Vec<Vec<u64>> = vec![
        vec![ 0,  2,  9, 10],
        vec![ 1,  0,  6,  4],
        vec![15,  7,  0,  8],
        vec![ 6,  3, 12,  0],
    ];

    let (cost, tour) = held_karp(&dist);
    println!("Minimum tour cost: {}", cost);
    print!("Tour: ");
    for v in &tour {
        print!("{} ", v);
    }
    println!();
}
