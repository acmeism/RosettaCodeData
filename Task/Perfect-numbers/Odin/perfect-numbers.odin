package perfect_numbers
import "core:fmt"
main :: proc() {
	fmt.println("\nPerfect numbers from 1 to 100,000:\n")
	for num in 1 ..< 100001 {
		if divisor_sum(num) == num {
			fmt.print("num:", num, "\n")
		}
		if num % 10000 == 0 {
			fmt.print("Count:", num, "\n")
		}
	}
}
divisor_sum :: proc(number: int) -> int {
	sum := 0
	for i in 1 ..< number {
		if number % i == 0 {
			sum += i}
	}
	return sum
}
