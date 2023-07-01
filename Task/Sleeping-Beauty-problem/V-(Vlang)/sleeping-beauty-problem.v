import rand
import rand.seed

fn sleeping_beauty(reps int) f64 {
    mut wakings := 0
    mut heads := 0
    for _ in 0..reps {
        coin := rand.intn(2) or {0} // heads = 0, tails = 1 say
        wakings++
        if coin == 0 {
            heads++
        } else {
            wakings++
        }
    }
    println("Wakings over $reps repetitions = $wakings")
    return f64(heads) / f64(wakings) * 100
}

fn main() {
    rand.seed(seed.time_seed_array(2))
    pc := sleeping_beauty(1000000)
    println("Percentage probability of heads on waking = $pc%")
}
