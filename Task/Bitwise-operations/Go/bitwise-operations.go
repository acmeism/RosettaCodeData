package main

import "fmt"

func bitwise(a, b int16) {
	fmt.Printf("a:   %016b\n", uint16(a))
	fmt.Printf("b:   %016b\n", uint16(b))

	// Bitwise logical operations
	fmt.Printf("and: %016b\n", uint16(a&b))
	fmt.Printf("or:  %016b\n", uint16(a|b))
	fmt.Printf("xor: %016b\n", uint16(a^b))
	fmt.Printf("not: %016b\n", uint16(^a))

	if b < 0 {
		fmt.Println("Right operand is negative, but all shifts require an unsigned right operand (shift distance).")
		return
	}
	ua := uint16(a)
	ub := uint32(b)

	// Logical shifts (unsigned left operand)
	fmt.Printf("shl: %016b\n", uint16(ua<<ub))
	fmt.Printf("shr: %016b\n", uint16(ua>>ub))

	// Arithmetic shifts (signed left operand)
	fmt.Printf("las: %016b\n", uint16(a<<ub))
	fmt.Printf("ras: %016b\n", uint16(a>>ub))

	// Rotations
	fmt.Printf("rol: %016b\n", uint16(a<<ub|int16(uint16(a)>>(16-ub))))
	fmt.Printf("ror: %016b\n", uint16(int16(uint16(a)>>ub)|a<<(16-ub)))
}

func main() {
	var a, b int16 = -460, 6
	bitwise(a, b)
}
