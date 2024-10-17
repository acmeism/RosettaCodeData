// [dependencies]
// primal = "0.3"
// mod_exp = "1.0"

fn wieferich_primes(limit: usize) -> impl std::iter::Iterator<Item = usize> {
    primal::Primes::all()
        .take_while(move |x| *x < limit)
        .filter(|x| mod_exp::mod_exp(2, *x - 1, *x * *x) == 1)
}

fn main() {
    let limit = 5000;
    println!("Wieferich primes less than {}:", limit);
    for p in wieferich_primes(limit) {
        println!("{}", p);
    }
}
