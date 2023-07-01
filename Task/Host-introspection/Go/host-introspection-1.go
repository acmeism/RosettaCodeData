package main

import (
	"fmt"
	"io/ioutil"
	"runtime"
	"strconv"
	"strings"
	"unsafe"
)

func main() {
	fmt.Println(runtime.Version(), runtime.GOOS, runtime.GOARCH)

	// Inspect a uint32 variable to determine endianness.
	x := uint32(0x01020304)
	switch *(*byte)(unsafe.Pointer(&x)) {
	case 0x01:
		fmt.Println("big endian")
	case 0x04:
		fmt.Println("little endian")
	default:
		fmt.Println("mixed endian?")
	}

	// Usually one cares about the size the executible was compiled for
	// rather than the actual underlying host's size.

	// There are several ways of determining the size of an int/uint.
	fmt.Println("         strconv.IntSize =", strconv.IntSize)
	// That uses the following definition we can also be done by hand
	intSize := 32 << uint(^uint(0)>>63)
	fmt.Println("32 << uint(^uint(0)>>63) =", intSize)

	// With Go 1.0, 64-bit architectures had 32-bit int and 64-bit
	// uintptr. This was changed in Go 1.1. In general it would
	// still be possible that int and uintptr (the type large enough
	// to hold the bit pattern of any pointer) are of different sizes.
	const bitsPerByte = 8
	fmt.Println("  sizeof(int)     in bits:", unsafe.Sizeof(int(0))*bitsPerByte)
	fmt.Println("  sizeof(uintptr) in bits:", unsafe.Sizeof(uintptr(0))*bitsPerByte)
	// If we really want to know the architecture size the executable was
	// compiled for and not the size of int it safest to take the max of those.
	archSize := unsafe.Sizeof(int(0))
	if psize := unsafe.Sizeof(uintptr(0)); psize > archSize {
		archSize = psize
	}
	fmt.Println("  compiled with word size:", archSize*bitsPerByte)

	// There are some *very* unportable ways to attempt to get the actual
	// underlying hosts' word size.
	// Inspect cpuinfo to determine word size (some unix-like OS' only).
	c, err := ioutil.ReadFile("/proc/cpuinfo")
	if err != nil {
		fmt.Println(err)
		return
	}
	ls := strings.Split(string(c), "\n")
	for _, l := range ls {
		if strings.HasPrefix(l, "flags") {
			for _, f := range strings.Fields(l) {
				if f == "lm" { // "long mode"
					fmt.Println("64 bit word size")
					return
				}
			}
			fmt.Println("32 bit word size")
			return
		}
	}
}
