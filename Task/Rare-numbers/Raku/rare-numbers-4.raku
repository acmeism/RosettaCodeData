use itertools::Itertools;
use std::collections::HashMap;

fn isqrt(n: u64) -> u64 {
    let mut s = (n as f64).sqrt() as u64;
    s = (s + n / s) >> 1;
    if s * s > n {
        s - 1
    } else {
        s
    }
}

fn is_square(n: u64) -> bool {
    match n & 0xf {
        0 | 1 | 4 | 9 => {
            let t = isqrt(n);
            t * t == n
        }
        _ => false,
    }
}

#[no_mangle]
/// This algorithm uses an advanced search strategy based on Nigel Galloway's approach
pub extern "C" fn advanced64(target: u8) -> *mut u64 {
    // setup
    let digit = 2u8;
    let mut results = Vec::new();
    let mut counter = 0_u8;

    let numeric_digits = (0..=9).map(|x| [x, 0]).collect::<Vec<_>>();
    let diffs1: Vec<i8> = vec![0, 1, 4, 5, 6];

    // all possible digits pairs to calculate potential diffs
    let pairs = (0_i8..=9)
        .cartesian_product(0_i8..=9)
        .map(|x| [x.0, x.1])
        .collect::<Vec<_>>();
    let all_diffs = (-9i8..=9).collect::<Vec<_>>();

    // lookup table for the first diff
    let lookup_1 = vec![
        vec![[2, 2], [8, 8]], //Diff = 0
        vec![[8, 7], [6, 5]], //Diff = 1
        vec![],
        vec![],
        vec![[4, 0]],         // Diff = 4
        vec![[8, 3]],         // Diff = 5
        vec![[6, 0], [8, 2]], // Diff = 6
    ];

    // lookup table for all the remaining diffs
    let lookup_n: HashMap<i8, Vec<_>> = pairs.into_iter().into_group_map_by(|elt| elt[0] - elt[1]);

    let mut d = digit;

    while target > counter {
        // powers like 1, 10, 100, 1000....
        let powers = (0..d).map(|x| 10_u64.pow(x.into())).collect::<Vec<u64>>();

        // for n-r (aka L) the required terms, like 9/ 99 / 999 & 90 / 99999 & 9999 & 900 etc
        let terms = powers
            .iter()
            .zip(powers.iter().rev())
            .map(|(a, b)| b.checked_sub(*a).unwrap_or(0))
            .filter(|x| *x != 0)
            .collect::<Vec<u64>>();

        // create a cartesian product for all potential diff numbers
        // for the first use the very short one, for all other the complete 19 element
        let diff_list_iter = (0_u8..(d / 2))
            .map(|i| match i {
                0 => diffs1.iter(),
                _ => all_diffs.iter(),
            })
            .multi_cartesian_product()
            // remove invalid first diff/second diff combinations - custom iterator would be probably better
            .filter(|x| {
                if x.len() == 1 {
                    return true;
                }
                match (*x[0], *x[1]) {
                    (a, b) if (a == 0 && b != 0) => false,
                    (a, b) if (a == 1 && ![-7, -5, -3, -1, 1, 3, 5, 7].contains(&b)) => false,
                    (a, b) if (a == 4 && ![-8, -6, -4, -2, 0, 2, 4, 6, 8].contains(&b)) => false,
                    (a, b) if (a == 5 && ![7, -3].contains(&b)) => false,
                    (a, b) if (a == 6 && ![-9, -7, -5, -3, -1, 1, 3, 5, 7, 9].contains(&b)) => {
                        false
                    }
                    _ => true,
                }
            });

        'OUTER: for diffs in diff_list_iter {
            // calculate difference of original n and its reverse (aka L = n-r)
            // which must be a perfect square
            let l: i64 = diffs
                .iter()
                .zip(terms.iter())
                .map(|(diff, term)| **diff as i64 * *term as i64)
                .sum();

            if l > 0 && is_square(l.try_into().unwrap()) {
                // potential candiate, at least L is a perfect square

                // placeholder for the digits
                let mut dig: Vec<i8> = vec![0_i8; d.into()];

                // generate a cartesian product for each identified diff using the lookup tables
                let c_iter = (0..(diffs.len() + d as usize % 2))
                    .map(|i| match i {
                        0 => lookup_1[*diffs[0] as usize].iter(),
                        _ if i != diffs.len() => lookup_n.get(diffs[i]).unwrap().iter(),
                        _ => numeric_digits.iter(), // for the middle digits
                    })
                    .multi_cartesian_product();

                // check each H (n+r) by using digit combination
                c_iter.for_each(|elt| {
                    for (i, digit_pair) in elt.iter().enumerate() {
                        dig[i] = digit_pair[0];
                        dig[d as usize - 1 - i] = digit_pair[1]
                    }

                    // for numbers with odd # digits restore the middle digit
                    // which has been overwritten at the end of the previous cycle
                    if d % 2 == 1 {
                        dig[(d as usize - 1) / 2] = elt[elt.len() - 1][0];
                    }

                    let num = dig
                        .iter()
                        .rev()
                        .enumerate()
                        .fold(0_u64, |acc, (i, d)| acc + 10_u64.pow(i as u32) * *d as u64);

                    let reverse = dig
                        .iter()
                        .enumerate()
                        .fold(0_u64, |acc, (i, d)| acc + 10_u64.pow(i as u32) * *d as u64);

                    if num > reverse && is_square(num + reverse) {
                        counter += 1;
                        results.push(num);
                    }
                });
                if counter == target {
                    break 'OUTER;
                }
            }
        }
        d += 1
    }
    let ptr = results.as_mut_ptr();
    std::mem::forget(results); // circumvent the destructor

    ptr
}
