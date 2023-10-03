package main

import (
	"fmt"
	"image"
	"reflect"
)

type t int // A type definition

// Some methods on the type
func (r t) Twice() t       { return r * 2 }
func (r t) Half() t        { return r / 2 }
func (r t) Less(r2 t) bool { return r < r2 }
func (r t) privateMethod() {}

func main() {
	report(t(0))
	report(image.Point{})
}

func report(x interface{}) {
	v := reflect.ValueOf(x)
	t := reflect.TypeOf(x) // or v.Type()
	n := t.NumMethod()
	fmt.Printf("Type %v has %d exported methods:\n", t, n)
	const format = "%-6s %-46s %s\n"
	fmt.Printf(format, "Name", "Method expression", "Method value")
	for i := 0; i < n; i++ {
		fmt.Printf(format,
			t.Method(i).Name,
			t.Method(i).Func.Type(),
			v.Method(i).Type(),
		)
	}
	fmt.Println()
}
