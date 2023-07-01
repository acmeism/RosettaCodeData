fn f(n: u32) -> u32 {
    match n {
        0 => 1,
        _ => n - m(f(n - 1))
    }
}

fn m(n: u32) -> u32 {
    match n {
        0 => 0,
        _ => n - f(m(n - 1))
    }
}

fn main() {
    for i in (0..20).map(f) {
        print!("{} ", i);
    }
    println!("");

    for i in (0..20).map(m) {
        print!("{} ", i);
    }
    println!("")
}
