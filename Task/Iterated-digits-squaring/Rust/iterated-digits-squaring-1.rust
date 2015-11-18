fn digit_square_sum(mut num: usize) -> usize {
    let mut sum = 0;
    while num != 0 {
        sum += (num % 10).pow(2);
        num /= 10;
    }
    sum
}

fn last_in_chain(num: usize) -> usize {
    match num {
        1 | 89 => num,
        _ => last_in_chain(digit_square_sum(num)),
    }
}

fn main() {
    let count = (1..100_000_000).filter(|&n| last_in_chain(n) == 89).count();
    println!("{}", count);
}
