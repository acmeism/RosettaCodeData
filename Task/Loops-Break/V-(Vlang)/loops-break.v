import rand
import rand.seed

fn main() {
    rand.seed(seed.time_seed_array(2))
    for {
        a := rand.intn(20)?
        println(a)
        if a == 10 {
            break
        }
        b := rand.intn(20)?
        println(b)
    }
}
