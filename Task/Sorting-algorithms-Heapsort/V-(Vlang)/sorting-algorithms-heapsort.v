fn main() {
	mut test_arr := [4, 65, 2, -31, 0, 99, 2, 83, 782, 1]	
	println('Before : $test_arr')
	heap_sort(mut test_arr)  // Heap Sort
	println('After : $test_arr')
}

[direct_array_access]
fn heap_sort(mut array []int) {
	n := array.len
	for i := n/2; i > -1; i-- {
		heapify(mut array, n, i)  // Max heapify
	}
	for i := n - 1; i > 0; i-- {
		array[i], array[0] = array[0], array[i]
		heapify(mut array, i, 0)
	}
}

[direct_array_access]
fn heapify(mut array []int, n int, i int) {
	mut largest := i
	left := 2 * i + 1
	right := 2 * i + 2
	if left < n && array[i] < array[left] {
		largest = left
	}
	if right < n && array[largest] < array[right] {
		largest = right
	}
	if largest != i {
		array[i], array[largest] = array[largest], array[i]
		heapify(mut array, n, largest)
	}
}
