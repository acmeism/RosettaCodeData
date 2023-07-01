fn shell(mut arr []int, n int) {
	mut j := 0
	for h := n; h /= 2;  {
		for i := h; i < n; i++ {
			t := arr[i]
			for j = i; j >= h && t < arr[j - h]; j -= h {
				arr[j] = arr[j - h]
			}
			arr[j] = t
		}
	}
}

fn main() {
	mut arr := [4, 65, 2, -31, 0, 99, 2, 83, 782, 1]
	n := arr.len
	println('Input: ' + arr.str())
	shell(mut arr, n)
	println('Output: ' + arr.str())
}
