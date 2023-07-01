package main

import "fmt"

func main() {
	// Go's builtin integer types are:
	//    int,  int8,  int16,  int32,  int64
	//   uint, uint8, uint16, uint32, uint64
	//   byte, rune, uintptr
	//
	// int is either 32 or 64 bit, depending on the system
	// uintptr is large enough to hold the bit pattern of any pointer
	// byte is 8 bits like int8
	// rune is 32 bits like int32
	//
	// Overflow and underflow is silent. The math package defines a number
	// of constants that can be helpfull, e.g.:
	//    math.MaxInt64  = 1<<63 - 1
	//    math.MinInt64  = -1 << 63
	//    math.MaxUint64 = 1<<64 - 1
	//
	// The math/big package implements multi-precision
	// arithmetic (big numbers).
	//
	// In all cases assignment from one type to another requires
	// an explicit cast, even if the types are otherwise identical
	// (e.g. rune and int32 or int and either int32 or int64).
	// Casts silently truncate if required.
	//
	// Invalid:
	//    var i int  = int32(0)
	//    var r rune = int32(0)
	//    var b byte = int8(0)
	//
	// Valid:
	var i64 int64 = 42
	var i32 int32 = int32(i64)
	var i16 int16 = int16(i64)
	var i8 int8 = int8(i16)
	var i int = int(i8)
	var r rune = rune(i)
	var b byte = byte(r)
	var u64 uint64 = uint64(b)
	var u32 uint32

	//const c int = -(-2147483647 - 1) // Compiler error on 32 bit systems, ok on 64 bit
	const c = -(-2147483647 - 1) // Allowed even on 32 bit systems, c is untyped
	i64 = c
	//i32 = c                          // Compiler error
	//i32 = -(-2147483647 - 1)         // Compiler error
	i32 = -2147483647
	i32 = -(-i32 - 1)
	fmt.Println("32 bit signed integers")
	fmt.Printf("  -(-2147483647 - 1) = %d, got %d\n", i64, i32)

	i64 = 2000000000 + 2000000000
	//i32 = 2000000000 + 2000000000    // Compiler error
	i32 = 2000000000
	i32 = i32 + i32
	fmt.Printf("  2000000000 + 2000000000 = %d, got %d\n", i64, i32)
	i64 = -2147483647 - 2147483647
	i32 = 2147483647
	i32 = -i32 - i32
	fmt.Printf("  -2147483647 - 2147483647 = %d, got %d\n", i64, i32)
	i64 = 46341 * 46341
	i32 = 46341
	i32 = i32 * i32
	fmt.Printf("  46341 * 46341 = %d, got %d\n", i64, i32)
	i64 = (-2147483647 - 1) / -1
	i32 = -2147483647
	i32 = (i32 - 1) / -1
	fmt.Printf("  (-2147483647-1) / -1 = %d, got %d\n", i64, i32)

	fmt.Println("\n64 bit signed integers")
	i64 = -9223372036854775807
	fmt.Printf("  -(%d - 1): %d\n", i64, -(i64 - 1))
	i64 = 5000000000000000000
	fmt.Printf("  %d + %d: %d\n", i64, i64, i64+i64)
	i64 = 9223372036854775807
	fmt.Printf("  -%d - %d: %d\n", i64, i64, -i64-i64)
	i64 = 3037000500
	fmt.Printf("  %d * %d: %d\n", i64, i64, i64*i64)
	i64 = -9223372036854775807
	fmt.Printf("  (%d - 1) / -1: %d\n", i64, (i64-1)/-1)

	fmt.Println("\n32 bit unsigned integers:")
	//u32 = -4294967295 // Compiler error
	u32 = 4294967295
	fmt.Printf("  -%d: %d\n", u32, -u32)
	u32 = 3000000000
	fmt.Printf("  %d + %d: %d\n", u32, u32, u32+u32)
	a := uint32(2147483647)
	u32 = 4294967295
	fmt.Printf("  %d - %d: %d\n", a, u32, a-u32)
	u32 = 65537
	fmt.Printf("  %d * %d: %d\n", u32, u32, u32*u32)

	fmt.Println("\n64 bit unsigned integers:")
	u64 = 18446744073709551615
	fmt.Printf("  -%d: %d\n", u64, -u64)
	u64 = 10000000000000000000
	fmt.Printf("  %d + %d: %d\n", u64, u64, u64+u64)
	aa := uint64(9223372036854775807)
	u64 = 18446744073709551615
	fmt.Printf("  %d - %d: %d\n", aa, u64, aa-u64)
	u64 = 4294967296
	fmt.Printf("  %d * %d: %d\n", u64, u64, u64*u64)
}
