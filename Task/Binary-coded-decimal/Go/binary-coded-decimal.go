package main

import (
	"fmt"
	"testing"
)

type bcd64 struct {
	bits uint64
}

func newBcd64(bits uint64) bcd64 {
	return bcd64{bits: bits}
}

func (b *bcd64) addAssign(other bcd64) *bcd64 {
	t1 := b.bits + 0x0666666666666666
	t2 := t1 + other.bits
	t3 := t1 ^ other.bits
	t4 := ^(t2 ^ t3) & 0x1111111111111110
	t5 := (t4 >> 2) | (t4 >> 3)
	b.bits = t2 - t5
	return b
}

func (b bcd64) negate() bcd64 {
	t1 := uint64(-int64(b.bits))
	t2 := t1 + 0xFFFFFFFFFFFFFFFF
	t3 := t2 ^ 1
	t4 := ^(t2 ^ t3) & 0x1111111111111110
	t5 := (t4 >> 2) | (t4 >> 3)
	return newBcd64(t1 - t5)
}

func (b bcd64) equals(other bcd64) bool {
	return b.bits == other.bits
}

func (b bcd64) add(other bcd64) bcd64 {
	sum := b
	sum.addAssign(other)
	return sum
}

func (b bcd64) subtract(other bcd64) bcd64 {
	return b.add(other.negate())
}

func (b bcd64) String() string {
	return fmt.Sprintf("0x%x", b.bits)
}

func main() {
	one := newBcd64(0x01)
	
	// Test cases with assertions
	result1 := newBcd64(0x19).add(one)
	if !result1.equals(newBcd64(0x20)) {
		panic(fmt.Sprintf("0x19 + 0x01 should be 0x20, got %s", result1))
	}
	fmt.Println(result1)
	
	result2 := newBcd64(0x30).subtract(one)
	if !result2.equals(newBcd64(0x29)) {
		panic(fmt.Sprintf("0x30 - 0x01 should be 0x29, got %s", result2))
	}
	fmt.Println(result2)
	
	result3 := newBcd64(0x99).add(one)
	if !result3.equals(newBcd64(0x100)) {
		panic(fmt.Sprintf("0x99 + 0x01 should be 0x100, got %s", result3))
	}
	fmt.Println(result3)
	
	// Alternative way to run tests
	runTests()
}

// Test function to match the assert behavior in the C++ code
func runTests() {
	t := &testing.T{}
	
	one := newBcd64(0x01)
	
	test(t, "0x19 + 0x01 = 0x20", newBcd64(0x19).add(one), newBcd64(0x20))
	test(t, "0x30 - 0x01 = 0x29", newBcd64(0x30).subtract(one), newBcd64(0x29))
	test(t, "0x99 + 0x01 = 0x100", newBcd64(0x99).add(one), newBcd64(0x100))
}

func test(t *testing.T, name string, got, want bcd64) {
	if !got.equals(want) {
		t.Errorf("%s: got %s, want %s", name, got, want)
	}
}
