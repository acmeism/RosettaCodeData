let powers: [uint; 10];

fn init() {
    for i in 1..10 { powers[i] = i ** i; }
}

fn munchausen(n: uint) -> bool {
    let nn = n;
    let sum: uint = 0;
    while n > 0 {
        let digit = n % 10;
        sum  += powers[digit];
        n /= 10;
    }
    return nn == sum;
}

fn main() {
    init();
    println "The Munchausen numbers <= 5000 are:";
    for let i: uint = 1; i <= 5000; ++i {
       if munchausen(i) { println "{i}"; }
    }
}
