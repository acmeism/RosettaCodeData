package main

import (
	"fmt"
	"unsafe"
)

func main() {
	myVar := 3.14
	myPointer := &myVar
	fmt.Println("Address:", myPointer, &myVar)
	fmt.Printf("Address: %p %p\n", myPointer, &myVar)

	var addr64 int64
	var addr32 int32
	ptr := unsafe.Pointer(myPointer)
	if unsafe.Sizeof(ptr) <= unsafe.Sizeof(addr64) {
		addr64 = int64(uintptr(ptr))
		fmt.Printf("Pointer stored in   int64: %#016x\n", addr64)
	}
	if unsafe.Sizeof(ptr) <= unsafe.Sizeof(addr32) {
		// Only runs on architectures where a pointer is <= 32 bits
		addr32 = int32(uintptr(ptr))
		fmt.Printf("Pointer stored in   int32: %#08x\n", addr32)
	}
	addr := uintptr(ptr)
	fmt.Printf("Pointer stored in uintptr: %#08x\n", addr)

	fmt.Println("value as float:", myVar)
	i := (*int32)(unsafe.Pointer(&myVar))
	fmt.Printf("value as int32: %#08x\n", *i)
}
