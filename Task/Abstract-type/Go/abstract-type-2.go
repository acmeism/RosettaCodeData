package main

import "fmt"

type Beast interface {
	Cry() string
}

type Pet struct{}
type Cat struct {
	Pet
}

func (p Pet) Name(b Beast) {
	fmt.Println(b.Cry())
}
func (p Pet) Cry() string {
	return "Woof"
}
func (c Cat) Cry() string {
	return "Meow"
}

func main() {
	p := Pet{}
	c := Cat{}
	p.Name(p) // prt Woof
	c.Name(c) // prt Meow
}
