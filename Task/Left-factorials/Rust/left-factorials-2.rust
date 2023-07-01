// [dependencies]
// rug = "1.9"

fn left_factorials() -> impl std::iter::Iterator<Item = rug::Integer> {
    use rug::Integer;
    let mut factorial = Integer::from(1);
    let mut next = Integer::from(0);
    let mut n = 1;
    std::iter::from_fn(move || {
        let result = next.clone();
        next += &factorial;
        factorial *= n;
        n += 1;
        Some(result)
    })
}

fn main() {
    let mut lf = left_factorials().take(10001).enumerate();
    println!("Left factorials 0 through 10:");
    for (i, n) in lf.by_ref().take(11) {
        println!("!{} = {}", i, n);
    }
    println!("Left factorials 20 through 110, by tens:");
    for (i, n) in lf.by_ref().take(100).skip(9).step_by(10) {
        println!("!{} = {}", i, n);
    }
    println!("Lengths of left factorials 1000 through 10000, by thousands:");
    for (i, n) in lf.skip(1000 - 111).step_by(1000) {
        println!("length of !{} = {}", i, n.to_string().len());
    }
}
