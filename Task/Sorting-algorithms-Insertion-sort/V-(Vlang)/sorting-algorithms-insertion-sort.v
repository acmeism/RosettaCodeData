fn insertion(mut arr []int) {
	for i in 1 .. arr.len {
		value := arr[i]
		mut j := i - 1
		for j >= 0 && arr[j] > value {
			arr[j + 1] = arr[j]
			j--
		}
		arr[j + 1] = value
	}
}

fn main() {
	mut arr := [4, 65, 2, -31, 0, 99, 2, 83, 782, 1]
	println('Input: ' + arr.str())
	insertion(mut arr)
	println('Output: ' + arr.str())
}
