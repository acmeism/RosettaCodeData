import time
import rand
import rand.pcg32
import rand.seed

fn main() {
    words := ['Enjoy', 'Rosetta', 'Code']
    seed_u64 := u64(time.now().unix_time_milli())
    q := chan string{}
    for i, w in words {
        go fn (q chan string, w string, seed_u64 u64) {
            mut rng := pcg32.PCG32RNG{}
            time_seed := seed.time_seed_array(2)
            seed_arr := [u32(seed_u64), u32(seed_u64 >> 32), time_seed[0], time_seed[1]]
            rng.seed(seed_arr)
            time.sleep(time.Duration(rng.i64n(1_000_000_000)))
            q <- w
        }(q, w, seed_u64 + u64(i))
    }
    for _ in 0 .. words.len {
        println(<-q)
    }
}
