fn main() {
    let mut powers = vec![0, 1, 4, 9, 16, 25, 36, 49, 64, 81];

    println!("Own digits power sums for N = 3 to 9 inclusive:");

    for n in 3..=9 {
        for d in 2..=9 {
            powers[d] *= d;
        }

        let mut i = 10u64.pow(n - 1);
        let max = i * 10;
        let mut last_digit = 0;
        let mut sum = 0;
        let mut digits: Vec<u32>;

        while i < max {
            if last_digit == 0 {
                digits = i.to_string()
                    .chars()
                    .map(|c| c.to_digit(10).unwrap())
                    .collect();
                sum = digits.iter().map(|&d| powers[d as usize]).sum();
            } else if last_digit == 1 {
                sum += 1;
            } else {
                sum += powers[last_digit as usize] - powers[(last_digit - 1) as usize];
            }

            if sum == i.try_into().unwrap() {
                println!("{}", i);
                if last_digit == 0 {
                    println!("{}", i + 1);
                }
                i += 10 - last_digit;
                last_digit = 0;
            } else if sum > i.try_into().unwrap() {
                i += 10 - last_digit;
                last_digit = 0;
            } else if last_digit < 9 {
                i += 1;
                last_digit += 1;
            } else {
                i += 1;
                last_digit = 0;
            }
        }
    }
}
