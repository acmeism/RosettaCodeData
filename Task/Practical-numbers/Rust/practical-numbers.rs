fn sum_of_any_subset(n: isize, f: &[isize]) -> bool {
    let len = f.len();
    if len == 0 {
        return false;
    }
    if f.contains(&n) {
        return true;
    }
    let mut total = 0;
    for i in 0..len {
        total += f[i];
    }
    if n == total {
        return true;
    }
    if n > total {
        return false;
    }
    let d = n - f[len - 1];
    let g = &f[0..len - 1];
    (d > 0 && sum_of_any_subset(d, g)) || sum_of_any_subset(n, g)
}

fn proper_divisors(n: isize) -> Vec<isize> {
    let mut f = vec![1];
    let mut i = 2;
    loop {
        let i2 = i * i;
        if i2 > n {
            break;
        }
        if n % i == 0 {
            f.push(i);
            if i2 != n {
                f.push(n / i);
            }
        }
        i += 1;
    }
    f.sort();
    f
}

fn is_practical(n: isize) -> bool {
    let f = proper_divisors(n);
    for i in 1..n {
        if !sum_of_any_subset(i, &f) {
            return false;
        }
    }
    true
}

fn shorten(v: &[isize], n: usize) -> String {
    let mut str = String::new();
    let len = v.len();
    let mut i = 0;
    if n > 0 && len > 0 {
        str.push_str(&v[i].to_string());
        i += 1;
    }
    while i < n && i < len {
        str.push_str(", ");
        str.push_str(&v[i].to_string());
        i += 1;
    }
    if len > i + n {
        if n > 0 {
            str.push_str(", ...");
        }
        i = len - n;
    }
    while i < len {
        str.push_str(", ");
        str.push_str(&v[i].to_string());
        i += 1;
    }
    str
}

fn main() {
    let from = 1;
    let to = 333;
    let mut practical = Vec::new();
    for n in from..=to {
        if is_practical(n) {
            practical.push(n);
        }
    }
    println!(
        "Found {} practical numbers between {} and {}:\n{}",
        practical.len(),
        from,
        to,
        shorten(&practical, 10)
    );
    for n in &[666, 6666, 66666, 672, 720, 222222] {
        if is_practical(*n) {
            println!("{} is a practical number.", n);
        } else {
            println!("{} is not practical number.", n);
        }
    }
}
