import rand
import rand.seed

fn shuffle(mut arr []int) {
    for i := arr.len - 1; i >= 0; i-- {
        j := rand.intn(i + 1)
        arr[i], arr[j] = arr[j], arr[i]
    }
    println('After Shuffle: $arr')
}

fn main() {
    seed_array := seed.time_seed_array(2)
    rand.seed(seed_array)
    mut arr := [6, 9, 1, 4]
    println('Input: $arr')
    shuffle(mut arr)
    shuffle(mut arr)
    println('Output: $arr')
}
