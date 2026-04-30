type Vector = []int
type Matrix = [][]int

fn spiral_matrix(n int) Matrix {
	mut result := [][]int{len: n, init: []int{len: n}}
	mut pos, mut sum := 0, -1
	mut count, mut value := n, -n
	for count > 0 {
		value = -value / n
		for _ in 0 .. count {
			sum += value
			result[sum / n][sum % n] = pos
			pos++
		}
		value *= n
		count--
		for _ in 0 .. count {
			sum += value
			result[sum / n][sum % n] = pos
			pos++
		}
	}
	return result
}

fn print_matrix(m Matrix) {
	for i := 0; i < m.len; i++ {
		for j := 0; j < m[i].len; j++ {
			print("${m[i][j]:2d} ")
		}
		println("")
	}
	println("")
}

fn main() {
	print_matrix(spiral_matrix(5))
	print_matrix(spiral_matrix(10))
}
