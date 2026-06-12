import rand
import rand.seed

fn generate(from i64, to i64) {
    if to < from || from < 0 {
        println("Invalid range.")
    }
    span := int(to - from + 1)
    mut generated := []bool{len: span} // all false by default, zero indexing
    mut count := span
    for count > 0 {
        n := from + rand.i64n(span) or {0} // upper endpoint is exclusive
        if !generated[n-from] {
            generated[n-from] = true
            print("${n} ")
            count--
        }
    }
    println('')
}

fn main(){
    rand.seed(seed.time_seed_array(2))
    // generate 5 sets say
    for i := 1; i <= 5; i++ {
        generate(1, 20)
    }
}
