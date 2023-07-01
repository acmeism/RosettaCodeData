package main

import "fmt"

type person struct{
    name string
    age int
}

func copy(p person) person {
    return person{p.name, p.age}
}

func main() {
    p := person{"Dave", 40}
    fmt.Println(p)
    q := copy(p)
    fmt.Println(q)
    /*
    is := []int{1, 2, 3}
    it := make([]int, 3)
    copy(it, is)
    */
}
