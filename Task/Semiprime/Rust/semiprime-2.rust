fn is_semiprime(n: usize) -> bool {
    fn iter(x: usize, start: usize, count: usize) -> usize {
        if count > 2 {return count} // break for semi_prime
        let limit = (x as f64).sqrt().ceil() as usize;
        match (start..=limit).skip_while(|i| x % i > 0).next() {
            Some(v) => iter(x / v, v, count + 1),
            None => if x < 2 { count }
                    else { count + 1 }
        }
    }
    iter(n, 2, 0) == 2
}
