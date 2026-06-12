use std::convert::TryInto;
use std::fmt;

fn print_vector<T: fmt::Display>(vec: &Vec<T>) {
    for element in vec {
        print!("{} ", element);
    }
}

fn factorial(number: u32) -> Result<u64, String> {
    if number > 20 {
        return Err(format!("Too large for 64 bit number: {}", number));
    }
    if number < 2 {
        return Ok(1);
    }

    let mut factorial: u64 = 1;
    for i in 2..=number {
        factorial *= u64::from(i);
    }
    Ok(factorial)
}

fn binomial(n: u32, k: u32) -> Result<u64, String> {
    let n_fact = factorial(n)?;
    let n_minus_k_fact = factorial(n - k)?;
    let k_fact = factorial(k)?;

    Ok(n_fact / n_minus_k_fact / k_fact)
}

fn forward(vec: &Vec<i64>) -> Result<Vec<i64>, String> {
    let size = vec.len();
    let mut transform: Vec<i64> = vec![0; size];

    for n in 0..size {
        for k in 0..=n {
            let binomial_coeff = binomial(n.try_into().unwrap(), k.try_into().unwrap())?;
            transform[n] += (binomial_coeff as i64) * vec[k];
        }
    }

    Ok(transform)
}

fn inverse(vec: &Vec<i64>) -> Result<Vec<i64>, String> {
    let size = vec.len();
    let mut transform: Vec<i64> = vec![0; size];

    for n in 0..size {
        for k in 0..=n {
            let binomial_coeff = binomial(n.try_into().unwrap(), k.try_into().unwrap())?;
            let sign: i32 = if (n - k) % 2 == 1 { -1 } else { 1 };
            transform[n] += (binomial_coeff as i64) * vec[k] * (sign as i64);
        }
    }

    Ok(transform)
}

fn self_inverting(vec: &Vec<i64>) -> Result<Vec<i64>, String> {
    let size = vec.len();
    let mut transform: Vec<i64> = vec![0; size];

    for n in 0..size {
        for k in 0..=n {
            let binomial_coeff = binomial(n.try_into().unwrap(), k.try_into().unwrap())?;
            let sign: i32 = if k % 2 == 1 { -1 } else { 1 };
            transform[n] += (binomial_coeff as i64) * vec[k] * (sign as i64);
        }
    }

    Ok(transform)
}

fn main() -> Result<(), String> {
    let sequences: Vec<Vec<i64>> = vec![
        vec![
            1, 1, 2, 5, 14, 42, 132, 429, 1430, 4862, 16796, 58786, 208012, 742900, 2674440,
            9694845,
        ],
        vec![0, 1, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0],
        vec![
            0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181,
        ],
        vec![
            1, 0, 0, 1, 0, 1, 1, 1, 2, 2, 3, 4, 5, 7, 9, 12, 16, 21, 28, 37,
        ],
    ];

    let names: Vec<String> = vec![
        "Catalan number sequence:".to_string(),
        "Prime flip-flop sequence:".to_string(),
        "Fibonacci number sequence:".to_string(),
        "Padovan number sequence:".to_string(),
    ];

    for i in 0..sequences.len() {
        println!("{}", names[i]);
        print_vector(&sequences[i]);
        println!("\nForward binomial transform:");
        print_vector(&forward(&sequences[i])?);
        println!("\nInverse binomial transform:");
        print_vector(&inverse(&sequences[i])?);
        println!("\nRound trip:");
        print_vector(&inverse(&forward(&sequences[i])?)?);
        println!("\nSelf-inverting:");
        print_vector(&self_inverting(&sequences[i])?);
        println!("\nRound trip self-inverting:");
        print_vector(&self_inverting(&self_inverting(&sequences[i])?)?);
        println!("\n\n");
    }

    Ok(())
}
