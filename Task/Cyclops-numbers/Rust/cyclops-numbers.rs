fn main() {
    let first50 = first_cyclops(50);
    println!("First 50 cyclops numbers:");
    print_vector(&first50, 10);

    let prime50 = first_cyclops_primes(50);
    println!("\nFirst 50 prime cyclops numbers:");
    print_vector(&prime50, 10);

    let blind50 = first_blind_cyclops_primes(50);
    println!("\nFirst 50 blind prime cyclops numbers:");
    print_vector(&blind50, 10);

    let palindrome50 = first_palindrome_cyclops_primes(50);
    println!("\nFirst 50 palindromic prime cyclops numbers:");
    print_vector(&palindrome50, 10);
}

fn print_vector(v: &[i32], nc: usize) {
    let mut col = 0;
    for e in v {
        print!("{:8}   ", e);
        col += 1;
        if col == nc {
            println!();
            col = 0;
        }
    }
}

fn is_cyclops_number(n: i32) -> bool {
    if n == 0 {
        return true;
    }

    let mut num = n;
    let mut m = num % 10;
    let mut count = 0;

    // Count digits before the zero
    while m != 0 {
        count += 1;
        num /= 10;
        m = num % 10;
    }

    // Skip the zero
    num /= 10;
    m = num % 10;

    // Count digits after the zero
    while m != 0 {
        count -= 1;
        num /= 10;
        m = num % 10;
    }

    num == 0 && count == 0
}

fn first_cyclops(n: usize) -> Vec<i32> {
    let mut result = Vec::new();
    let mut i = 0;

    while result.len() < n {
        if is_cyclops_number(i) {
            result.push(i);
        }
        i += 1;
    }

    result
}

fn is_prime(n: i32) -> bool {
    if n < 2 {
        return false;
    }

    let sqrt_n = (n as f64).sqrt() as i32;
    for i in 2..=sqrt_n {
        if n % i == 0 {
            return false;
        }
    }

    true
}

fn first_cyclops_primes(n: usize) -> Vec<i32> {
    let mut result = Vec::new();
    let mut i = 0;

    while result.len() < n {
        if is_cyclops_number(i) && is_prime(i) {
            result.push(i);
        }
        i += 1;
    }

    result
}

fn blind_cyclops(n: i32) -> i32 {
    let mut num = n;
    let mut m = num % 10;
    let mut k = 0;

    // Extract digits before the zero
    while m != 0 {
        k = 10 * k + m;
        num /= 10;
        m = num % 10;
    }

    // Skip the zero
    num /= 10;

    // Reconstruct the number by reversing the first part
    while k != 0 {
        m = k % 10;
        num = 10 * num + m;
        k /= 10;
    }

    num
}

fn first_blind_cyclops_primes(n: usize) -> Vec<i32> {
    let mut result = Vec::new();
    let mut i = 0;

    while result.len() < n {
        if is_cyclops_number(i) && is_prime(i) {
            let j = blind_cyclops(i);
            if is_prime(j) {
                result.push(i);
            }
        }
        i += 1;
    }

    result
}

fn is_palindrome(n: i32) -> bool {
    let mut k = 0;
    let mut l = n;

    while l != 0 {
        let m = l % 10;
        k = 10 * k + m;
        l /= 10;
    }

    n == k
}

fn first_palindrome_cyclops_primes(n: usize) -> Vec<i32> {
    let mut result = Vec::new();
    let mut i = 0;

    while result.len() < n {
        if is_cyclops_number(i) && is_prime(i) && is_palindrome(i) {
            result.push(i);
        }
        i += 1;
    }

    result
}
