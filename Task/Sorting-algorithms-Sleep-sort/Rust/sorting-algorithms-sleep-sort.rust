use std::thread;

fn sleepsort<I: Iterator<Item=u32>>(nums: I) {
    let threads: Vec<_> = nums.map(|n|
        thread::spawn(move || {
            thread::sleep_ms(n);
            println!("{}", n); })).collect();
    for t in threads { t.join(); }
}

fn main() {
    sleepsort(std::env::args().skip(1).map(|s| s.parse().unwrap()));
}
