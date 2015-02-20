package main

import (
	"bufio"
	"errors"
	"fmt"
	"os"
	"reflect"
	"unsafe"
)

type foobar struct {
	Exported   int // In Go identifiers that are capitalized are exported,
	unexported int // while lowercase identifiers are not.
}

func main() {
	obj := foobar{12, 42}
	fmt.Println("obj:", obj)

	examineAndModify(&obj)
	fmt.Println("obj:", obj)

	anotherExample()
}

// For simplicity this skips several checks. It assumes the thing in the
// interface is a pointer without checking (v.Kind()==reflect.Ptr),
// it then assumes it is a structure type with two int fields
// (v.Kind()==reflect.Struct, f.Type()==reflect.TypeOf(int(0))).
func examineAndModify(any interface{}) {
	v := reflect.ValueOf(any) // get a reflect.Value
	v = v.Elem()              // dereference the pointer
	fmt.Println(" v:", v, "=", v.Interface())
	t := v.Type()
	// Loop through the struct fields
	fmt.Printf("    %3s %-10s %-4s %s\n", "Idx", "Name", "Type", "CanSet")
	for i := 0; i < v.NumField(); i++ {
		f := v.Field(i) // reflect.Value of the field
		fmt.Printf("    %2d: %-10s %-4s %t\n", i,
			t.Field(i).Name, f.Type(), f.CanSet())
	}

	// "Exported", field 0, has CanSet==true so we can do:
	v.Field(0).SetInt(16)
	// "unexported", field 1, has CanSet==false so the following
	// would fail at run-time with:
	//   panic: reflect: reflect.Value.SetInt using value obtained using unexported field
	//v.Field(1).SetInt(43)

	// However, we can bypass this restriction with the unsafe
	// package once we know what type it is (so we can use the
	// correct pointer type, here *int):
	vp := v.Field(1).Addr()   // Take the fields's address
	uip := vp.Pointer()       // … get an int value of the address
	up := unsafe.Pointer(uip) // … convert it "unsafely"
	p := (*int)(up)           // … and end up with what we want/need
	fmt.Printf("  vp has type %-14T = %v\n", vp, vp)
	fmt.Printf(" uip has type %-14T = %#0x\n", uip, uip)
	fmt.Printf("  up has type %-14T = %#0x\n", up, up)
	fmt.Printf("   p has type %-14T = %v pointing at %v\n", p, p, *p)
	*p = 43 // effectively obj.unexported = 43
	// or an incr all on one ulgy line:
	*(*int)(unsafe.Pointer(v.Field(1).Addr().Pointer()))++
}

// This time we'll use an external package to demonstrate that it's not
// restricted to things defined locally. We'll mess with bufio.Reader's
// interal workings by happening to know they have a non-exported
// "err error" field. Of course future versions of Go may not have this
// field or use it in the same way :).
func anotherExample() {
	r := bufio.NewReader(os.Stdin)

	// Do the dirty stuff in one ugly and unsafe statement:
	errp := (*error)(unsafe.Pointer(
		reflect.ValueOf(r).Elem().FieldByName("err").Addr().Pointer()))
	*errp = errors.New("unsafely injected error value into bufio inner workings")

	_, err := r.ReadByte()
	fmt.Println("bufio.ReadByte returned error:", err)
}
