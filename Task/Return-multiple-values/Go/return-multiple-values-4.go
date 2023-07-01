package main

import (
	"fmt"
)

// Return multiple values using a function
func Pet(name, color string) (string, string) {
	color = "white"
	return name, color
}

// Change multiple global values using a function and a struct
type Beast struct {
	Cry, Play string
}

var Fluffy = Beast{"Meow", "Mice"}

func myBeast() {
	Fluffy.Cry = "Hiss"
	// Fluffy.Play = "Ball"
}

// Return multiple values using a function and an array
func Cat(newCat []string) []string {
	newCat = append(newCat, "Milk")
	return newCat
}

// Return multiple values using a method and a struct
type Tabby struct {
	Sleep string
	Cry   string
}

func (myTab Tabby) Puss() (string, string) {
	myTab.Sleep = "Zzzz"
	myTab.Cry = "Purr"
	return myTab.Sleep, myTab.Cry
}

func main() {
	// Return multiple values using a function
	name, color := Pet("Shadow", "Black")
	fmt.Println(name, color) // prt Puss Black

	// Change multiple global values using a function and a struct
	// fmt.Println(Fluffy.Cry, Fluffy.Play) // prt Meow Mice
	myBeast()
	fmt.Println(Fluffy.Cry, Fluffy.Play) // prt Purr Ball

	// Return multiple values using a function and an array
	newCat := make([]string, 2)
	newCat[0] = "Ginger"
	newCat[1] = "Orange"
	myPuss := Cat(newCat)
	fmt.Println(myPuss[1], myPuss[2]) // prt Orange Milk

	// Return multiple values using a method and a struct
	myCat := Tabby{Sleep: "Snore", Cry: "Meow"}
	puss, poo := myCat.Puss()
	fmt.Println(puss, poo) // prt Kitty Cat
}
