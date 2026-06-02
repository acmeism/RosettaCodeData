import "std/random.zc"

fn main() {
    let rng = Random::new();
    loop {
        let a = rng.next_int_range(0, 19);
        println "{a}";
        if a == 10 { break; }
        let b = rng.next_int_range(0, 19);
        println "{b}";
    }
}
