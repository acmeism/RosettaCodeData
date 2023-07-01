fn bubble(mut arr []int) {
        println('Input: ${arr.str()}')
        mut count := arr.len
        for {
                if count <= 1 {
                        break
                }
                mut has_changed := false
                count--
                for i := 0; i < count; i++ {
                        if arr[i] > arr[i + 1] {
                                temp := arr[i + 1]
                                arr[i + 1] = arr[i]
                                arr[i] = temp
                                has_changed = true
                        }
                }
                if !has_changed {
                        break
                }
        }
        println('Output: ${arr.str()}')
}

fn main() {
        mut arr := [3, 5, 2, 1, 4]
        bubble(mut arr)
}
