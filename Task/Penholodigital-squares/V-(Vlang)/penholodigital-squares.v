import math
import strconv

const digits = "0123456789abcdef"
const largest_prime_factors = [u32(1), 2, 3, 2, 5, 3, 7, 2, 3, 5, 11, 3, 13, 7, 5]

// Convert decimal to string representation in the given radix/base
fn decimal_to_base(pum u64, radix u32) string {
	mut num := pum
	mut result := []u8{}
	if num == 0 { return "0" }
	for num > 0 {
		result << digits[int(num % u64(radix))]
		num /= u64(radix)
	}
	result.reverse()
	return result.bytestr()
}

// Count unique characters in a string
fn uniq_chrs_count(word string) int {
	mut seen := map[rune]bool{}
	for chr in word { seen[chr] = true }
	return seen.len
}

fn main() {
	mut penholo, mut penholo_squares := []string{}, []string{}
	mut min_f64, mut max_f64 := f64(0), f64(0)
	mut min, mut max, mut divisor := u32(0), u32(0), u32(0)
	mut radix_digits :=""
	for radix in 2 .. 17 {
		penholo.clear()
		penholo_squares.clear()
		radix_digits = digits[1..radix]
		min_f64 = math.ceil(math.sqrt(strconv.parse_uint(radix_digits, int(radix), 64) or { 0 }))
		max_f64 = math.floor(math.sqrt(strconv.parse_uint(radix_digits.reverse(), int(radix), 64) or { 0 }))
		min = u32(min_f64)
		max = u32(max_f64)
		divisor = largest_prime_factors[radix - 2]

		if min % divisor != 0 { min += divisor - (min % divisor) }

		for num := min; num <= max; num += divisor {
			square := decimal_to_base(u64(num) * u64(num), u32(radix)).runes()
			square_no_zero := square.filter(it != `0`)

			if uniq_chrs_count(square_no_zero.string()) == radix - 1 {
				penholo << decimal_to_base(u64(num), u32(radix))
				penholo_squares << square_no_zero.string()
			}
		}

		println("There is a total of ${penholo.len} penholodigital squares in base $radix:")

		if radix <= 13 {
			for idx, val in penholo {
				print("${val.reverse()}² = ${penholo_squares[idx].reverse()}")
				if idx % 3 == 2 { println("") }
				else { print("    ") }
			}
			if penholo.len % 3 != 0 { println("") }
			println("")
		}
		else {
			if penholo.len > 0 {
				print("${penholo[0].reverse()}² = ${penholo_squares[0].reverse()} ... ")
				print("${penholo[penholo.len - 1].reverse()}² = ")
				println("${penholo_squares[penholo_squares.len - 1].reverse()}\n")
			}
			else { println("") }
		}
	}
}
