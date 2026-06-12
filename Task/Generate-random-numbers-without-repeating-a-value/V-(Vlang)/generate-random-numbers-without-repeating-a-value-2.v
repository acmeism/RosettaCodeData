import rand
import rand.seed

fn main(){
    rand.seed(seed.time_seed_array(2))
    mut numbers := []int{len:20, init:it+1}
    // generate 5 sets say
    for i := 1; i <= 5; i++ {
        rand.shuffle<int>(mut numbers, rand.ShuffleConfigStruct{})?
        s := "${numbers:2} "
        println(s[1 .. s.len-2])
    }
}
