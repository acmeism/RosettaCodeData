package main
// stackoverflow.com/questions/28432398/difference-between-some-operators-golang
import "fmt"

func main() {
	// Use bitwise OR | to get the bits that are in 1 OR 2
	// 1     = 00000001
	// 2     = 00000010
	// 1 | 2 = 00000011 = 3
	fmt.Println(1 | 2)

	// Use bitwise OR | to get the bits that are in 1 OR 5
	// 1     = 00000001
	// 5     = 00000101
	// 1 | 5 = 00000101 = 5
	fmt.Println(1 | 5)

	// Use bitwise XOR ^ to get the bits that are in 3 OR 6 BUT NOT BOTH
	// 3     = 00000011
	// 6     = 00000110
	// 3 ^ 6 = 00000101 = 5
	fmt.Println(3 ^ 6)

	// Use bitwise AND & to get the bits that are in 3 AND 6
	// 3     = 00000011
	// 6     = 00000110
	// 3 & 6 = 00000010 = 2
	fmt.Println(3 & 6)

	// Use bit clear AND NOT &^ to get the bits that are in 3 AND NOT 6 (order matters)
	// 3      = 00000011
	// 6      = 00000110
	// 3 &^ 6 = 00000001 = 1
	fmt.Println(3 &^ 6)
}
