const digits = [[1, 10], [1234, 10], [0xfe, 16], [0xf0e, 16]]

fn main() {
	for val in digits {println(sum_digits(val[0], val[1]))}
}

fn sum_digits(num int, base int) int {
	mut sum, mut temp := 0, num
	for temp > 0 {
		sum += temp % base
		temp /= base
	}
	return sum
}
