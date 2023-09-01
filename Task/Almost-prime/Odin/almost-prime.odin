package almostprime
import "core:fmt"
main :: proc() {
	i, c, k: int
	for k in 1 ..= 5 {
		fmt.printf("k = %d:", k)
		for i, c := 2, 0; c < 10; i += 1 {
			if kprime(i, k) {
				fmt.printf(" %v", i)
				c += 1
			}
		}
		fmt.printf("\n")
	}
}
kprime :: proc(n: int, k: int) -> bool {
	p, f: int = 0, 0
	n := n
	for p := 2; f < k && p * p <= n; p += 1 {
		for (0 == n % p) {
			n /= p
			f += 1
		}
	}
	return f + (n > 1 ? 1 : 0) == k
}
