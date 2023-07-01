// [dependencies]
// primal = "0.3"

fn print_diffs(vec: &[usize]) {
    for i in 0..vec.len() {
        if i > 0 {
            print!(" ({}) ", vec[i] - vec[i - 1]);
        }
        print!("{}", vec[i]);
    }
    println!();
}

fn main() {
    let limit = 1000000;
    let mut asc = Vec::new();
    let mut desc = Vec::new();
    let mut max_asc = Vec::new();
    let mut max_desc = Vec::new();
    let mut max_asc_len = 0;
    let mut max_desc_len = 0;
    for p in primal::Sieve::new(limit)
        .primes_from(2)
        .take_while(|x| *x < limit)
    {
        let alen = asc.len();
        if alen > 1 && p - asc[alen - 1] <= asc[alen - 1] - asc[alen - 2] {
            asc = asc.split_off(alen - 1);
        }
        asc.push(p);
        if asc.len() >= max_asc_len {
            if asc.len() > max_asc_len {
                max_asc_len = asc.len();
                max_asc.clear();
            }
            max_asc.push(asc.clone());
        }
        let dlen = desc.len();
        if dlen > 1 && p - desc[dlen - 1] >= desc[dlen - 1] - desc[dlen - 2] {
            desc = desc.split_off(dlen - 1);
        }
        desc.push(p);
        if desc.len() >= max_desc_len {
            if desc.len() > max_desc_len {
                max_desc_len = desc.len();
                max_desc.clear();
            }
            max_desc.push(desc.clone());
        }
    }
    println!("Longest run(s) of ascending prime gaps up to {}:", limit);
    for v in max_asc {
        print_diffs(&v);
    }
    println!("\nLongest run(s) of descending prime gaps up to {}:", limit);
    for v in max_desc {
        print_diffs(&v);
    }
}
