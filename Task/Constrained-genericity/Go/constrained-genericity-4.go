package main

import "fmt"

type eatable interface {
    eat()
}

type foodbox []eatable

type peelfirst string

func (f peelfirst) eat() {
    // peel code goes here
    fmt.Println("mm, that", f, "was good!")
}

func main() {
    fb := foodbox{peelfirst("banana"), peelfirst("mango")}
    f0 := fb[0]
    f0.eat()
}
