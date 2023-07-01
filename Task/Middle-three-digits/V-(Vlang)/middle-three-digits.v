import math

const
(
	valid = [123, 12345, 1234567, 987654321, 10001, -10001, -123, -100, 100, -12345]
	invalid = [1, 2, -1, -10, 2002, -2002, 0]
)

fn main() {
	for elem in valid {println(middle(elem))}
	for elem in invalid {println(middle(elem))}
}


fn middle(num int) string {
	mut strip := math.abs(num).str()
	if strip.len < 3 {return 'Error: $num has less than 3 digits'}
	if strip.len % 2 == 0 {return 'Error: $num has an even number of digits'}
	start := (strip.len / 2) - 1
	return strip.substr(start, start + 3)
}
