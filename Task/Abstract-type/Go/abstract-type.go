package main

import "fmt"

type Beast interface {
    Kind() string
    Name() string
    Cry() string
}

type Dog struct {
    kind string
    name string
}

func (d Dog) Kind() string { return d.kind }

func (d Dog) Name() string { return d.name }

func (d Dog) Cry() string { return "Woof" }

type Cat struct {
    kind string
    name string
}

func (c Cat) Kind() string { return c.kind }

func (c Cat) Name() string { return c.name }

func (c Cat) Cry() string { return "Meow" }

func bprint(b Beast) {
    fmt.Printf("%s, who's a %s, cries: %q.\n", b.Name(), b.Kind(), b.Cry())
}

func main() {
    d := Dog{"labrador", "Max"}
    c := Cat{"siamese", "Sammy"}
    bprint(d)
    bprint(c)
}
