fn f(n: i64) -> i64 {
    n + (0.5 + (n as f64).sqrt()) as i64
}

fn is_sqr(n: i64) -> bool {
    let a = (n as f64).sqrt() as i64;
    n == a * a || n == (a+1) * (a+1) || n == (a-1) * (a-1)
}

fn main() {
    println!( "{:?}", (1..23).map(|n| f(n)).collect::<Vec<i64>>() );
    let count = (1..1_000_000).map(|n| f(n)).filter(|&n| is_sqr(n)).count();
    println!("{} unexpected squares found", count);
}
