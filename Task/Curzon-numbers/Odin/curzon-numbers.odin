package curzon_numbers
/* imports */
import "core:c/libc"
import "core:fmt"
/* main block */
main :: proc() {
	for k: int = 2; k <= 10; k += 2 {
		fmt.println("\nCurzon numbers with base ", k)
		count := 0
		n: int = 1
		for ; count < 50; n += 1 {
			if is_curzon(n, k) {
				count += 1
				libc.printf("%*d ", 4, n)
				if (count) % 10 == 0 {
					fmt.printf("\n")
				}
			}
		}
		for {
			if is_curzon(n, k) {
				count += 1}
			if count == 1000 {
				break}
			n += 1
		}
		libc.printf("1000th Curzon number with base %d: %d \n", k, n)
	}
}
/* definitions */
modpow :: proc(base, exp, mod: int) -> int {
	if mod == 1 {
		return 0}
	result: int = 1
	base := base
	exp := exp
	base %= mod
	for ; exp > 0; exp >>= 1 {
		if ((exp & 1) == 1) {
			result = (result * base) % mod}
		base = (base * base) % mod
	}
	return result
}

is_curzon :: proc(n: int, k: int) -> bool {
	r := k * n //const?
	return modpow(k, n, r + 1) == r
}
