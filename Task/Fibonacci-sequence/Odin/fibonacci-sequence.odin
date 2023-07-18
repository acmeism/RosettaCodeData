package fib
import "core:fmt"

main :: proc() {
	fmt.println("\nFibonacci Seq - starting n and n+1 from 0 and 1:")
	fmt.println("------------------------------------------------")
	for j: u128 = 0; j <= 20; j += 1 {
		fmt.println("n:", j, "\tFib:", fibi(j))
	}
}

fibi :: proc(n: u128) -> u128 {
    if n < 2 {
        return n
    }
    a, b: u128 = 0, 1
    for _ in 2..=n {
        a += b
        a, b = b, a
    }
    return b
}
