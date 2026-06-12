use std::collections::HashSet;

#[derive(Debug, Clone, Default)]
struct Set {
    items: HashSet<String>,
}

fn b2s(mut i: usize, vars: usize) -> String {
    let mut s = String::with_capacity(vars);
    for _ in 0..vars {
        s.push(if i & 1 == 1 { '1' } else { '0' });
        i >>= 1;
    }
    s.chars().rev().collect()
}

fn bit_count(s: &str) -> usize {
    s.chars().filter(|&c| c == '1').count()
}

fn merge(i: &str, j: &str) -> String {
    let len = i.len().min(j.len());
    let mut dif_cnt = 0;
    let mut s = String::with_capacity(len);
    let mut it_i = i.chars();
    let mut it_j = j.chars();

    for _ in 0..len {
        let a = it_i.next().unwrap();
        let b = it_j.next().unwrap();
        if a == 'X' || b == 'X' {
            if a != b {
                return String::new();
            }
            s.push(a);
        } else if a != b {
            dif_cnt += 1;
            if dif_cnt > 1 {
                return String::new();
            }
            s.push('X');
        } else {
            s.push(a);
        }
    }
    s
}

fn add_to_set(set: &mut Set, item: String) {
    set.items.insert(item);
}

fn in_set(set: &Set, item: &str) -> bool {
    set.items.contains(item)
}

fn union_sets(dest: &mut Set, src: &Set) {
    dest.items.extend(src.items.iter().cloned());
}

fn compute_primes(cubes: &Set, vars: usize, primes: &mut Set) {
    let mut sigma: Vec<Set> = vec![Set::default(); vars + 1];
    let mut sigma_count = 0;

    for cube in &cubes.items {
        let bc = bit_count(cube);
        if bc <= vars {
            add_to_set(&mut sigma[bc], cube.clone());
        }
    }

    for j in 0..=vars {
        if !sigma[j].items.is_empty() {
            sigma_count = j + 1;
        }
    }

    primes.items.clear();
    let mut sigma = sigma;

    while sigma_count > 0 {
        let mut nsigma: Vec<Set> = (0..(sigma_count - 1)).map(|_| Set::default()).collect();
        let mut redundant = Set::default();

        for i in 0..(sigma_count - 1) {
            let c1 = &sigma[i];
            let c2 = &sigma[i + 1];
            let mut nc = Set::default();

            for a in &c1.items {
                for b in &c2.items {
                    let m = merge(a, b);
                    if !m.is_empty() {
                        add_to_set(&mut nc, m.clone());
                        add_to_set(&mut redundant, a.clone());
                        add_to_set(&mut redundant, b.clone());
                    }
                }
            }
            nsigma[i] = nc;
        }

        for i in 0..sigma_count {
            for cube in &sigma[i].items {
                if !in_set(&redundant, cube) {
                    add_to_set(primes, cube.clone());
                }
            }
        }

        sigma = nsigma;
        sigma_count = sigma.len();
    }
}

fn active_primes(cubesel: usize, primes: &Set, result: &mut Set) {
    result.items.clear();
    let s = b2s(cubesel, primes.items.len());
    for (i, prime) in primes.items.iter().enumerate() {
        if s.chars().nth(i).unwrap() == '1' {
            add_to_set(result, prime.clone());
        }
    }
}

fn is_cover(prime: &str, one: &str) -> bool {
    let len = prime.len().min(one.len());
    for (p, o) in prime.chars().zip(one.chars()).take(len) {
        if p != 'X' && p != o {
            return false;
        }
    }
    true
}

fn is_full_cover(all_primes: &Set, ones: &Set) -> bool {
    for one in &ones.items {
        let mut covered = false;
        for prime in &all_primes.items {
            if is_cover(prime, one) {
                covered = true;
                break;
            }
        }
        if !covered {
            return false;
        }
    }
    true
}

fn unate_cover(primes: &Set, ones: &Set, result: &mut Set) {
    let mut min_count = usize::MAX;
    let mut min_sel: Option<usize> = None;
    let total = 1 << primes.items.len();

    for cubesel in 0..total {
        let mut active = Set::default();
        active_primes(cubesel, primes, &mut active);
        if is_full_cover(&active, ones) {
            let cnt = cubesel.count_ones() as usize;
            if cnt < min_count {
                min_count = cnt;
                min_sel = Some(cubesel);
            }
        }
    }

    if let Some(sel) = min_sel {
        active_primes(sel, primes, result);
    } else {
        result.items.clear();
    }
}

fn qm(ones: &[usize], zeros: &[usize], dc: &[usize], result: &mut Set) {
    if ones.is_empty() && zeros.is_empty() && dc.is_empty() {
        return;
    }

    let max_val = ones
        .iter()
        .chain(zeros.iter())
        .chain(dc.iter())
        .max()
        .copied()
        .unwrap_or(0);

    let numvars = if max_val == 0 {
        1
    } else {
        (usize::BITS - max_val.leading_zeros()) as usize
    };

    let mut ones_set = Set::default();
    for &val in ones {
        add_to_set(&mut ones_set, b2s(val, numvars));
    }

    let mut cubes = Set::default();
    union_sets(&mut cubes, &ones_set);

    let mut dc_set = Set::default();
    for &val in dc {
        add_to_set(&mut dc_set, b2s(val, numvars));
    }
    union_sets(&mut cubes, &dc_set);

    let mut primes = Set::default();
    compute_primes(&cubes, numvars, &mut primes);

    unate_cover(&primes, &ones_set, result);
}

fn main() {
    let ones = vec![1, 2, 5];
    let zeros: Vec<usize> = vec![];
    let dc = vec![0, 7];

    let mut result = Set::default();
    qm(&ones, &zeros, &dc, &mut result);

    for item in &result.items {
        println!("{}", item);
    }
}
