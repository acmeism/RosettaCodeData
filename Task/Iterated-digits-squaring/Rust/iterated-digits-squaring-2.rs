fn dig_sq_sum(mut num : usize ) -> usize {
    let mut sum = 0;
    while num != 0 {
        sum += (num % 10).pow(2);
        num /= 10;
    }
    sum
}

fn last_in_chain(num: usize) -> usize {
    match num {
        0 => 0,
        1 | 89 => num,
        _ => last_in_chain(dig_sq_sum(num)),
    }
}

fn main() {
    let prec: Vec<_> = (0..649).map(|n| last_in_chain(n)).collect();
    let count = (1..100_000_000).filter(|&n| prec[dig_sq_sum(n)] == 89).count();
    println!("{}", count);
}
