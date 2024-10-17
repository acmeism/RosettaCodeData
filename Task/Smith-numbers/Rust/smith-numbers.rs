fn main () {
    //We just need the primes below 100
    let primes = vec![2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97];
    let mut solution = Vec::new();
    let mut number;
    for i in 4..10000 {
        //Factorize each number below 10.000
        let mut prime_factors = Vec::new();
        number = i;
        for j in &primes {
            while number % j == 0 {
                number = number / j;
                prime_factors.push(j);
            }
            if number == 1 { break; }
        }
        //Number is 1 (not a prime factor) if the factorization is complete or a prime bigger than 100
        if number != 1 { prime_factors.push(&number); }
        //Avoid the prime numbers
        if prime_factors.len() < 2 { continue; }
        //Check the smith number definition
        if prime_factors.iter().fold(0, |n,x| n + x.to_string().chars().map(|d| d.to_digit(10).unwrap()).fold(0, |n,x| n + x))
            == i.to_string().chars().map(|d| d.to_digit(10).unwrap()).fold(0, |n,x| n + x) {
            solution.push(i);
        }
    }
    println!("Smith numbers below 10000 ({}) : {:?}",solution.len(), solution);
}
