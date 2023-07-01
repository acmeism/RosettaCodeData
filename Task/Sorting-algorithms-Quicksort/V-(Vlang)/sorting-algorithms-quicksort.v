fn partition(mut arr []int, low int, high int) int {
	pivot := arr[high]
	mut i := (low - 1)
	for j in low .. high {
		if arr[j] < pivot {
			i++
			temp := arr[i]
			arr[i] = arr[j]
			arr[j] = temp
		}
	}
	temp := arr[i + 1]
	arr[i + 1] = arr[high]
	arr[high] = temp
	return i + 1
}

fn quick_sort(mut arr []int, low int, high int) {
	if low < high {
		pi := partition(mut arr, low, high)
		quick_sort(mut arr, low, pi - 1)
		quick_sort(mut arr, pi + 1, high)
	}
}

fn main() {
	mut arr := [4, 65, 2, -31, 0, 99, 2, 83, 782, 1]
	n := arr.len - 1
	println('Input: ' + arr.str())
	quick_sort(mut arr, 0, n)
	println('Output: ' + arr.str())
}
