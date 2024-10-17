fn choose(n:u64,k:u64)->u64 {
   let factorial=|x| (1..=x).fold(1, |a, x| a * x);
   factorial(n) / factorial(k) / factorial(n - k)
}
