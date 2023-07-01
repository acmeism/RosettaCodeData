package main

import (
	"fmt"
	"reflect"
	"strconv"
)

func main() {
	var n bool = true
	fmt.Println(n)        // prt true
	fmt.Printf("%T\n", n) // prt bool
	n = !n
	fmt.Println(n) // prt false

	x := 5
	y := 8
	fmt.Println("x == y:", x == y) // prt x == y: false
	fmt.Println("x < y:", x < y)   // prt x < y: true

	fmt.Println("\nConvert String into Boolean Data type\n")
	str1 := "japan"
	fmt.Println("Before :", reflect.TypeOf(str1)) // prt Before : string
	bolStr, _ := strconv.ParseBool(str1)
	fmt.Println("After :", reflect.TypeOf(bolStr)) // prt After : bool
}
