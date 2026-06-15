use std::ops::Div;

fn is_prime(limit: u32) -> impl Fn(&u32) -> bool {
    let mut sieve = vec![true; limit as usize + 1];
    sieve[0] = false;
    sieve[1] = false;
    for i in 2..=limit.isqrt() {
        if sieve[i as usize] {
            (i * i..=limit).step_by(i as usize).for_each(|j| {
                sieve[j as usize] = false;
            });
        }
    }
    move |n| sieve[*n as usize]
}

fn main() {
    let is_prime = is_prime(333);
    (3..33)
        .filter(|p| is_prime(p))
        .flat_map(|p| {
            (p + 1..=1000_u32.div(p))
                .filter(|q| is_prime(q))
                .map(move |q| p * q)
        })
        .enumerate()
        .for_each(|(idx, value)| {
            if (idx + 1) % 15 == 0 {
                print!("{:3}\n", value);
            } else {
                print!("{:3} ", value);
            }
        });
    println!();
}
