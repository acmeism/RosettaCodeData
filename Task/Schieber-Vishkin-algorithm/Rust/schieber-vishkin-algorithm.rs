use std::cmp;

#[derive(Clone, Default)]
struct Node {
    child: usize,
    sib: usize,
    parent: usize,
}

fn process(n: usize, a: &mut Vec<i32>) -> (Vec<usize>, Vec<usize>, Vec<usize>, Vec<usize>, Vec<i32>) {
    let mut pi = vec![0; n + 1];
    let mut beta = vec![0; n + 1];
    let mut alfa = vec![0; n + 1];
    let mut tau = vec![0; n + 1];
    let mut lam = vec![0; n + 1];
    lam[0] = -1; // Change this to i32 instead of usize
    let mut nodes = vec![Node::default(); n + 1];

    // Make triply linked tree
    let mut t = 0;
    for v in (1..=n).rev() {
        let mut u = 0;
        while a[v] > a[t] || (a[v] == a[t] && v > t) {
            u = t;
            t = nodes[t].parent;
        }

        if u != 0 {
            nodes[v].sib = nodes[u].sib;
            nodes[u].sib = 0;
            nodes[u].parent = v;
            nodes[v].child = u;
        } else {
            nodes[v].sib = nodes[t].child;
        }

        nodes[t].child = v;
        nodes[v].parent = t;
        t = v;
    }

    // Begin first traversal
    let mut p = nodes[0].child;
    let mut n_count = 0;

    // First traversal loop (replaces goto-based control flow)
    loop {
        // s3: Compute beta in the easy case
        n_count += 1;
        pi[p] = n_count;
        tau[n_count] = 0;
        lam[n_count] = 1 + lam[n_count >> 1];

        if nodes[p].child != 0 {
            p = nodes[p].child;
            continue;
        }

        beta[p] = n_count;

        // s4: Compute tau, bottom-up
        loop {
            tau[beta[p]] = nodes[p].parent;

            if nodes[p].sib != 0 {
                p = nodes[p].sib;
                break; // Go back to s3
            }

            p = nodes[p].parent;

            // Compute beta in the hard case
            if p != 0 {
                let h = lam[(n_count & (!pi[p] + 1)) as usize];
                beta[p] = ((n_count >> h as usize) | 1) << h as usize;
            } else {
                // Exit traversal
                break;
            }
        }

        if p == 0 {
            break;
        }
    }

    // Begin second traversal
    p = nodes[0].child;
    lam[0] = lam[n_count];
    pi[0] = 0;
    beta[0] = 0;
    alfa[0] = 0;

    // Recursive function for second traversal
    fn compute_alfa(
        p: usize,
        nodes: &[Node],
        alfa: &mut [usize],
        beta: &[usize],
    ) {
        // s7: Compute alfa, top-down
        alfa[p] = alfa[nodes[p].parent] | (beta[p] & (!beta[p] + 1));

        if nodes[p].child != 0 {
            compute_alfa(nodes[p].child, nodes, alfa, beta);
        }

        // s8: Continue traversal
        if nodes[p].sib != 0 {
            compute_alfa(nodes[p].sib, nodes, alfa, beta);
        }
    }

    // Perform second traversal
    if p != 0 {
        compute_alfa(p, &nodes, &mut alfa, &beta);
    }

    (pi, beta, alfa, tau, lam)
}

fn nca(
    mut x: usize,
    mut y: usize,
    beta: &[usize],
    alfa: &[usize],
    tau: &[usize],
    lam: &[i32], // Changed to i32
    pi: &[usize],
) -> usize {
    // Find common height
    let h = if beta[x] <= beta[y] {
        lam[(beta[y] & (!beta[x] + 1)) as usize]
    } else {
        lam[(beta[x] & (!beta[y] + 1)) as usize]
    };

    // Find true height
    let k = alfa[x] & alfa[y] & (!(1 << h as usize) + 1);
    let h = lam[(k & (!k + 1)) as usize];

    // Find beta[z]
    let j = ((beta[x] >> h as usize) | 1) << h as usize;

    // Find x' and y'
    if j != beta[x] {
        let l = lam[(alfa[x] & ((1 << h as usize) - 1)) as usize];
        x = tau[((beta[x] >> l as usize) | 1) << l as usize];
    }

    if j != beta[y] {
        let l = lam[(alfa[y] & ((1 << h as usize) - 1)) as usize];
        y = tau[((beta[y] >> l as usize) | 1) << l as usize];
    }

    // Find z
    if pi[x] <= pi[y] { x } else { y }
}

fn solve_test_case(
    n: usize,
    values: &[i32],
    queries: &[(usize, usize)],
) -> Vec<i32> {
    let mut results = Vec::new();

    let mut a = vec![i32::MAX];  // A[0]
    let mut r = vec![0; n + 2];
    let mut b = vec![0; n + 2];

    let mut big_n = 1;
    let mut count = 0;
    let mut oldx = None;

    for i in 1..=n {
        let x = values[i - 1];

        if i > 1 && Some(x) != oldx {
            a.push(count);
            r[big_n] = i;
            big_n += 1;
            count = 0;
        }

        b[i] = big_n;
        count += 1;
        oldx = Some(x);
    }

    a.push(count);
    r[big_n] = n + 1;

    let (pi, beta, alfa, tau, lam) = process(big_n, &mut a);

    for &(i, j) in queries {
        let x = b[i];
        let y = b[j];

        let z = if x == y {
            (j - i + 1) as i32
        } else {
            let mut z = if x + 1 != y {
                a[nca(x + 1, y - 1, &beta, &alfa, &tau, &lam, &pi)]
            } else {
                0
            };

            z = cmp::max(z, cmp::max(
                (r[x] - i) as i32,
                a[y] - (r[y] - j - 1) as i32
            ));

            z
        };

        results.push(z);
    }

    results
}

fn main() {
    // Hard-coded test data
    let test_cases = [
        (
            10,
            vec![-1, -1, 1, 1, 1, 1, 3, 10, 10, 10],
            vec![(2, 3), (1, 10), (5, 10)],
            vec![1, 4, 3]
        )
    ];

    for (idx, (n, values, queries, expected)) in test_cases.iter().enumerate() {
        println!("Test Case {}:", idx + 1);
        println!("Size: {}, Queries: {}", n, queries.len());
        print!("Values: ");
        for v in values {
            print!("{} ", v);
        }
        println!();

        let results = solve_test_case(*n, values, queries);

        println!("Queries and Results:");
        // Fixed iterator pattern
        for q_idx in 0..queries.len() {
            let (i, j) = queries[q_idx];
            let result = results[q_idx];
            let exp = expected[q_idx];

            println!("Query: {} {}", i, j);
            println!("Result: {} (Expected: {})", result, exp);
            if result != exp {
                println!("  WARNING: Result doesn't match expected output");
            }
        }

        println!();
    }
}
