// [dependencies]
// num-format = "0.4"

// Returns the sum of the digits of n given the
// sum of the digits of n - 1
fn digit_sum(mut n: u64, mut sum: u64) -> u64 {
    sum += 1;
    while n > 0 && n % 10 == 0 {
        sum -= 9;
        n /= 10;
    }
    sum
}

fn divisible(n: u64, d: u64) -> bool {
    if (d & 1) == 0 && (n & 1) == 1 {
        return false;
    }
    n % d == 0
}

fn main() {
    use num_format::{Locale, ToFormattedString};
    let mut previous = 1;
    let mut gap = 0;
    let mut sum = 0;
    let mut niven_index = 0;
    let mut gap_index = 1;
    let mut niven = 1;
    println!("Gap index  Gap    Niven index    Niven number");
    while gap_index <= 32 {
        sum = digit_sum(niven, sum);
        if divisible(niven, sum) {
            if niven > previous + gap {
                gap = niven - previous;
                println!(
                    "{:9} {:4} {:>14} {:>15}",
                    gap_index,
                    gap,
                    niven_index.to_formatted_string(&Locale::en),
                    previous.to_formatted_string(&Locale::en)
                );
                gap_index += 1;
            }
            previous = niven;
            niven_index += 1;
        }
        niven += 1;
    }
}
