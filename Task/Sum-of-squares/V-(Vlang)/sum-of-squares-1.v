fn main() {
	a_list := [1, 2, 3, 4, 5]
	println(sum_of_squares(a_list))
}

fn sum_of_squares(int_arr []int) int {
	mut sum := 0
    for _, elem in int_arr {
        sum += elem * elem
    }
	return sum
}
