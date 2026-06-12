// Return the Sturmian word for the strictly positive rational number m / n
fn sturmian_word_rational(m: u32, n: u32) -> String {
    if m > n {
        let inverse = sturmian_word_rational(n, m);
        return inverse
            .chars()
            .map(|ch| if ch == '0' { '1' } else { '0' })
            .collect();
    }

    let mut sturmian = String::new();
    let mut k = 1u32;

    while (k * m) % n != 0 {
        let previous_floor = ((k - 1) * m) / n;
        let current_floor = (k * m) / n;

        if previous_floor == current_floor {
            sturmian.push('0');
        } else {
            sturmian.push_str("10");
        }
        k += 1;
    }

    sturmian
}

// Return the first 'letter_count' letters of Sturmian word for the strictly positive real number
// ( b * √(a) + m ) / n, where a is not a perfect square
fn sturmian_word_quadratic(b: i32, a: u32, m: i32, n: i32, letter_count: u32) -> String {
    let mut p = vec![0u32, 1u32];
    let mut q = vec![1u32, 0u32];
    let mut remainder = (b as f64 * (a as f64).sqrt() + m as f64) / n as f64;

    for _i in 1..=letter_count {
        let integer_part = remainder.floor() as i32;
        let fraction_part = remainder - integer_part as f64;

        let pn = (integer_part * p[p.len() - 1] as i32 + p[p.len() - 2] as i32) as u32;
        let qn = (integer_part * q[q.len() - 1] as i32 + q[q.len() - 2] as i32) as u32;

        p.push(pn);
        q.push(qn);
        remainder = 1.0 / fraction_part;
    }

    sturmian_word_rational(p[p.len() - 1], q[q.len() - 1])
}

// Return the Fibonacci word for the given integer
// For more information visit https://en.wikipedia.org/wiki/Fibonacci_word
fn fibonacci_word(number: u32) -> String {
    if number == 0 {
        return String::new();
    }
    if number == 1 {
        return "0".to_string();
    }

    let mut previous = "0".to_string();
    let mut result = "01".to_string();

    for _i in 2..number {
        let temp = result.clone();
        result = result + &previous;
        previous = temp;
    }

    result
}

fn main() {
    let sturmian = sturmian_word_rational(13, 21);
    println!("{} from rational number 13 / 21", sturmian);

    let quadratic_result = sturmian_word_quadratic(1, 5, -1, 2, 8);
    println!("{} from real number ( √5 - 1 ) / 2, the first 8 letters", quadratic_result);

    let fibonacci = fibonacci_word(10);
    let sturmian_equals_fibonacci = sturmian == &fibonacci[..sturmian.len().min(fibonacci.len())];
    println!("Sturmian word equals Fibonacci word? : {}", sturmian_equals_fibonacci);
}
