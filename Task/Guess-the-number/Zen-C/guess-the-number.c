import "std/random.zc"

fn main() {
    let rng = Random::new();
    let comp = rng.next_int_range(1, 10); // computer number
    let attempt = 0
    let guess: int
    do {
        ? "Your guess 1 to 10 : " (guess);
        attempt++;
    } while comp != guess;
    println "\nYou guessed correctly after {attempt} attempt(s)!";
}
