package main

import "fmt"

type typeid int

const (
    PARENT typeid = iota
    CHILD
)

type parent struct {
    name string
    age  int
}

type child struct {
    parent // embedded struct
}

func (p *parent) watchMovie(id typeid) {
    if id == CHILD && p.age < 15 {
        fmt.Printf("Sorry, %s, you are too young to watch the movie.\n", p.name)
    } else {
        fmt.Printf("%s is watching the movie...\n", p.name)
    }
}

func main() {
    p := &parent{"Donald", 42}
    p.watchMovie(PARENT)
    c1 := &child{parent{"Lisa", 18}}
    c2 := &child{parent{"Fred", 10}}
    c1.watchMovie(CHILD)
    c2.watchMovie(CHILD)
}
