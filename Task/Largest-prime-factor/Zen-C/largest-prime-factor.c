fn largest_prime_factor(n: u64) -> u64 {
    if n < 2 { return 1; }
    let inc: int[8] = [4, 2, 4, 2, 4, 6, 2, 6];
    let largest: u64;
    while n % 2 == 0 {
        largest = 2;
        n /= 2;
    }
    while n % 3 == 0 {
        largest = 3;
        n /= 3;
    }
    while n % 5 == 0 {
        largest = 5;
        n /= 5;
    }
    let k: u64 = 7;
    let i: usize = 0;
    while k * k <= n {
        if n % k == 0 {
            largest = k;
            n /= k;
        } else {
            k += inc[i];
            i = (i + 1) % 8;
        }
    }
    if n > 1 { largest = n; }
    return largest;
}

fn main() {
    let n: u64 = 600_851_475_143;
    println "{largest_prime_factor(n)}";
}
