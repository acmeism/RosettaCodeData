fn counting_sort(mut arr []int, min int, max int) {
	println('Input: ' + arr.str())
	mut count := [0].repeat(max - min + 1)
	for i in 0 .. arr.len {
		nbr := arr[i]
		ndx1 := nbr - min
		count[ndx1] = count[ndx1] + 1
	}
	mut z := 0
	for i in min .. max {
		curr := i - min
		for count[curr] > 0 {
			arr[z] = i
			z++
			count[curr]--
		}
	}
	println('Output: ' + arr.str())
}

fn main() {
	mut arr := [6, 2, 1, 7, 6, 8]
	counting_sort(mut arr, 1, 8)
}
