import "std/random.zc"

fn main() {
    let rng = Random::new();
    let planets = ["Earth", "Venus", "Mercury", "Mars", "Jupiter"];
    // Permits repeats.
    for _ in 0..5 {
        let r = rng.next_int_range(0, 4);
        println "{planets[r]}";
    }
}
