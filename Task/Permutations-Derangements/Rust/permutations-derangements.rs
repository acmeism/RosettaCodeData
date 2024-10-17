fn deranged(depth: usize, len: usize, d: &mut Vec<u8>, show: bool) -> i128 {
    let mut count: i128 = 0;

    if depth == len {
        if show {
            for i in 0..len {
                print!("{}", (d[i] + 'a' as u8) as char);
            }
            println!();
        }
        return 1_i128;
    }
    for i in (depth..len).rev() {
        if i != d[depth].into() {
            let mut tmp = d[i];
            d[i] = d[depth];
            d[depth] = tmp;
            count += deranged(depth + 1, len, d, show);
            tmp = d[i];
            d[i] = d[depth];
            d[depth] = tmp;
        }
    }
    return count;
}

fn gen_n(n: usize, show: bool) -> i128 {
    let a = &mut [0_u8; 1024].to_vec();
    for i in 0..n {
        a[i] = i as u8;
    }
    return deranged(0, n, a, show);
}

fn sub_fact(n: usize) -> i128 {
    return if n < 2 {
        (1 - n) as i128
    } else {
        (sub_fact(n - 1) + sub_fact(n - 2)) * ((n - 1) as i128)
    };
}

fn main() {
    println!("Deranged Four:");
    gen_n(4, true);

    println!("\nCompare list vs calc:");
    for i in 0..10 {
        println!("{}:\t{}\t{}", i, gen_n(i, false), sub_fact(i));
    }

    println!("\nfurther calc:");
    for i in 10..33 {
        println!("{}: {}", i, sub_fact(i));
    }
}
