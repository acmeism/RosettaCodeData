import rand

fn shuffle_array(mut arr []int) {
    for i := arr.len - 1; i >= 0; i-- {
        j := rand.intn(i + 1)
        arr[i], arr[j] = arr[j], arr[i]
    }
}

fn is_sorted(arr []int) bool {
    for i := 0; i < arr.len - 1; i++ {
        if arr[i] > arr[i + 1] {
            return false
        }
    }
    return true
}

fn sort_array(mut arr []int) {
    for !is_sorted(arr) {
        shuffle_array(mut arr)
        println('After Shuffle: $arr')
    }
}

fn main() {
    mut array := [6, 9, 1, 4]
    println('Input: $array')
    sort_array(mut array)
    println('Output: $array')
}
