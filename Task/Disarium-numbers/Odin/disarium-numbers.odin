package disarium
import "core:fmt"
import "core:math"

/* main block start */
main :: proc() {
	fmt.print("\nThe first 18 Disarium numbers are:")
	count, i: int
	for count < 19 {
		if is_disarium(i) {
			fmt.print(" ", i)
			count += 1
		}
		i += 1
	}
	fmt.println("")
} /* main block end */

/* proc definitions */
power :: proc(base, exponent: int) -> int {
	result := 1
	for _ in 1 ..= exponent {
		result *= base
	}
	return result
}

is_disarium :: proc(num: int) -> bool {
	n := num
	sum := 0
	len := n <= 9 ? 1 : cast(int)math.floor_f64(math.log10_f64(auto_cast n) + 1)
	for n > 0 {
		sum += power(n % 10, len)
		n /= 10
		len -= 1
	}
	return num == sum
}
