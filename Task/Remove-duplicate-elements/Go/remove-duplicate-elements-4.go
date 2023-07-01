package main

import (
	"fmt"
	"math"
	"reflect"
)

func uniq(x interface{}) (interface{}, bool) {
	v := reflect.ValueOf(x)
	if !v.IsValid() {
		panic("uniq: invalid argument")
	}
	if k := v.Kind(); k != reflect.Array && k != reflect.Slice {
		panic("uniq: argument must be an array or a slice")
	}
	elemType := v.Type().Elem()
	intType := reflect.TypeOf(int(0))
	mapType := reflect.MapOf(elemType, intType)
	m := reflect.MakeMap(mapType)
	i := 0
	for j := 0; j < v.Len(); j++ {
		x := v.Index(j)
		if m.MapIndex(x).IsValid() {
			continue
		}
		m.SetMapIndex(x, reflect.ValueOf(i))
		if m.MapIndex(x).IsValid() {
			i++
		}
	}
	sliceType := reflect.SliceOf(elemType)
	result := reflect.MakeSlice(sliceType, i, i)
	hadNaN := false
	for _, key := range m.MapKeys() {
		ival := m.MapIndex(key)
		if !ival.IsValid() {
			hadNaN = true
		} else {
			result.Index(int(ival.Int())).Set(key)
		}
	}

	return result.Interface(), hadNaN
}

type MyType struct {
	name  string
	value float32
}

func main() {
	intArray := [...]int{5, 1, 2, 3, 2, 3, 4}
	intSlice := []int{5, 1, 2, 3, 2, 3, 4}
	stringSlice := []string{"five", "one", "two", "three", "two", "three", "four"}
	floats := []float64{1, 2, 2, 4,
		math.NaN(), 2, math.NaN(),
		math.Inf(1), math.Inf(1), math.Inf(-1), math.Inf(-1)}
	complexes := []complex128{1, 1i, 1 + 1i, 1 + 1i,
		complex(math.NaN(), 1), complex(1, math.NaN()),
		complex(math.Inf(+1), 1), complex(1, math.Inf(1)),
		complex(math.Inf(-1), 1), complex(1, math.Inf(1)),
	}
	structs := []MyType{
		{"foo", 42},
		{"foo", 2},
		{"foo", 42},
		{"bar", 42},
		{"bar", 2},
		{"fail", float32(math.NaN())},
	}

	fmt.Print("intArray: ", intArray, " → ")
	fmt.Println(uniq(intArray))
	fmt.Print("intSlice: ", intSlice, " → ")
	fmt.Println(uniq(intSlice))
	fmt.Print("stringSlice: ", stringSlice, " → ")
	fmt.Println(uniq(stringSlice))
	fmt.Print("floats: ", floats, " → ")
	fmt.Println(uniq(floats))
	fmt.Print("complexes: ", complexes, "\n → ")
	fmt.Println(uniq(complexes))
	fmt.Print("structs: ", structs, " → ")
	fmt.Println(uniq(structs))
	// Passing a non slice or array will compile put
	// then produce a run time panic:
	//a := 42
	//uniq(a)
	//uniq(nil)
}
