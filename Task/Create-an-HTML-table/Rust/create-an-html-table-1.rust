extern crate rand;

use rand::Rng;

fn random_cell<R: Rng>(rng: &mut R) -> u32 {
    // Anything between 0 and 10_000 (exclusive) has 4 digits or fewer. Using `gen_range::<u32>`
    // is faster for smaller RNGs.  Because the parameters are constant, the compiler can do all
    // the range construction at compile time, removing the need for
    // `rand::distributions::range::Range`
    rng.gen_range(0, 10_000)
}

fn main() {
    let mut rng = rand::thread_rng(); // Cache the RNG for reuse

    println!("<table><thead><tr><th></th><td>X</td><td>Y</td><td>Z</td></tr></thead>");

    for row in 0..3 {
        let x = random_cell(&mut rng);
        let y = random_cell(&mut rng);
        let z = random_cell(&mut rng);
        println!("<tr><th>{}</th><td>{}</td><td>{}</td><td>{}</td></tr>", row, x, y, z);
    }

    println!("</table>");
}
