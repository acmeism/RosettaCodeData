package main

import (
	"fmt"
	"math"
	"math/big"
	"reflect"
	"strings"
	"unsafe"
)

// Go provides an integerness test only for the big.Rat and big.Float types
// in the standard library.

// The fundamental piece of code needed for built-in floating point types
// is a test on the float64 type:

func Float64IsInt(f float64) bool {
	_, frac := math.Modf(f)
	return frac == 0
}

// Other built-in or stanadard library numeric types are either always
// integer or can be easily tested using Float64IsInt.

func Float32IsInt(f float32) bool {
	return Float64IsInt(float64(f))
}

func Complex128IsInt(c complex128) bool {
	return imag(c) == 0 && Float64IsInt(real(c))
}

func Complex64IsInt(c complex64) bool {
	return imag(c) == 0 && Float64IsInt(float64(real(c)))
}

// Usually just the above statically typed functions would be all that is used,
// but if it is desired to have a single function that can test any arbitrary
// type, including the standard math/big types, user defined types based on
// an integer, float, or complex builtin types, or user defined types that
// have an IsInt() method, then reflection can be used.

type hasIsInt interface {
	IsInt() bool
}

var bigIntT = reflect.TypeOf((*big.Int)(nil))

func IsInt(i interface{}) bool {
	if ci, ok := i.(hasIsInt); ok {
		// Handles things like *big.Rat
		return ci.IsInt()
	}
	switch v := reflect.ValueOf(i); v.Kind() {
	case reflect.Int, reflect.Int8, reflect.Int16,
		reflect.Int32, reflect.Int64,
		reflect.Uint, reflect.Uint8, reflect.Uint16,
		reflect.Uint32, reflect.Uint64, reflect.Uintptr:
		// Built-in types and any custom type based on them
		return true
	case reflect.Float32, reflect.Float64:
		// Built-in floats and anything based on them
		return Float64IsInt(v.Float())
	case reflect.Complex64, reflect.Complex128:
		// Built-in complexes and anything based on them
		return Complex128IsInt(v.Complex())
	case reflect.String:
		// Could also do strconv.ParseFloat then FloatIsInt but
		// big.Rat handles everything ParseFloat can plus more.
		// Note, there is no strconv.ParseComplex.
		if r, ok := new(big.Rat).SetString(v.String()); ok {
			return r.IsInt()
		}
	case reflect.Ptr:
		// Special case for math/big.Int
		if v.Type() == bigIntT {
			return true
		}
	}
	return false
}

// The rest is just demonstration and display

type intbased int16
type complexbased complex64
type customIntegerType struct {
	// Anything that stores or represents a sub-set
	// of integer values in any way desired.
}

func (customIntegerType) IsInt() bool    { return true }
func (customIntegerType) String() string { return "<…>" }

func main() {
	hdr := fmt.Sprintf("%27s  %-6s %s\n", "Input", "IsInt", "Type")
	show2 := func(t bool, i interface{}, args ...interface{}) {
		istr := fmt.Sprint(i)
		fmt.Printf("%27s  %-6t %T ", istr, t, i)
		fmt.Println(args...)
	}
	show := func(i interface{}, args ...interface{}) {
		show2(IsInt(i), i, args...)
	}

	fmt.Print("Using Float64IsInt with float64:\n", hdr)
	neg1 := -1.
	for _, f := range []float64{
		0, neg1 * 0, -2, -2.000000000000001, 10. / 2, 22. / 3,
		math.Pi,
		math.MinInt64, math.MaxUint64,
		math.SmallestNonzeroFloat64, math.MaxFloat64,
		math.NaN(), math.Inf(1), math.Inf(-1),
	} {
		show2(Float64IsInt(f), f)
	}

	fmt.Print("\nUsing Complex128IsInt with complex128:\n", hdr)
	for _, c := range []complex128{
		3, 1i, 0i, 3.4,
	} {
		show2(Complex128IsInt(c), c)
	}

	fmt.Println("\nUsing reflection:")
	fmt.Print(hdr)
	show("hello")
	show(math.MaxFloat64)
	show("9e100")
	f := new(big.Float)
	show(f)
	f.SetString("1e-3000")
	show(f)
	show("(4+0i)", "(complex strings not parsed)")
	show(4 + 0i)
	show(rune('§'), "or rune")
	show(byte('A'), "or byte")
	var t1 intbased = 5200
	var t2a, t2b complexbased = 5 + 0i, 5 + 1i
	show(t1)
	show(t2a)
	show(t2b)
	x := uintptr(unsafe.Pointer(&t2b))
	show(x)
	show(math.MinInt32)
	show(uint64(math.MaxUint64))
	b, _ := new(big.Int).SetString(strings.Repeat("9", 25), 0)
	show(b)
	r := new(big.Rat)
	show(r)
	r.SetString("2/3")
	show(r)
	show(r.SetFrac(b, new(big.Int).SetInt64(9)))
	show("12345/5")
	show(new(customIntegerType))
}
