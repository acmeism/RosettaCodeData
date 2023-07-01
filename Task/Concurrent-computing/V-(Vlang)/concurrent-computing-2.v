import time
import rand
import rand.pcg32
import rand.seed

fn main() {
    words := ['Enjoy', 'Rosetta', 'Code']
    mut threads := []thread{} // mutable array to hold the id of the thread
    for w in words {
        threads << go fn (w string) { // record the thread
            mut rng := pcg32.PCG32RNG{}
            time_seed := seed.time_seed_array(4) // the time derived array to seed the random generator
            rng.seed(time_seed)
            time.sleep(time.Duration(rng.i64n(1_000_000_000)))
            println(w)
        }(w)
    }
    threads.wait() // join the thread waiting. wait() is defined for threads and arrays of threads
}
