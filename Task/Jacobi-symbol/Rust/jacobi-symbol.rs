fn jacobi(mut n: i32, mut k: i32) -> i32 {
    assert!(k > 0 && k % 2 == 1);
    n %= k;
    let mut t = 1;
    while n != 0 {
        while n % 2 == 0 {
            n /= 2;
            let r = k % 8;
            if r == 3 || r == 5 {
                t = -t;
            }
        }
        std::mem::swap(&mut n, &mut k);
        if n % 4 == 3 && k % 4 == 3 {
            t = -t;
        }
        n %= k;
    }
    if k == 1 {
        t
    } else {
        0
    }
}

fn print_table(kmax: i32, nmax: i32) {
    print!("n\\k|");
    for k in 0..=kmax {
        print!(" {:2}", k);
    }
    print!("\n----");
    for _ in 0..=kmax {
        print!("---");
    }
    println!();
    for n in (1..=nmax).step_by(2) {
        print!("{:2} |", n);
        for k in 0..=kmax {
            print!(" {:2}", jacobi(k, n));
        }
        println!();
    }
}

fn main() {
    print_table(20, 21);
}
