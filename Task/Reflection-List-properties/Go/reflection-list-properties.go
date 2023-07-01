package main

import (
	"fmt"
	"image"
	"reflect"
)

// A type definition
type t struct {
	X    int
	next *t
}

func main() {
	report(t{})
	report(image.Point{})
}

func report(x interface{}) {
	t := reflect.TypeOf(x)
	n := t.NumField()
	fmt.Printf("Type %v has %d fields:\n", t, n)
	fmt.Println("Name     Type     Exported")
	for i := 0; i < n; i++ {
		f := t.Field(i)
		fmt.Printf("%-8s %-8v %-8t\n",
			f.Name,
			f.Type,
			f.PkgPath == "",
		)
	}
	fmt.Println()
}
