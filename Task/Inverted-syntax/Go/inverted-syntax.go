package main

import "fmt"

type ibool bool

const itrue ibool = true

func (ib ibool) iif(cond bool) bool {
    if cond {
        return bool(ib)
    }
    return bool(!ib)
}

func main() {
    var needUmbrella bool
    raining := true

    // normal syntax
    if raining {
        needUmbrella = true
    }
    fmt.Printf("Is it raining? %t. Do I need an umbrella? %t\n", raining, needUmbrella)

    // inverted syntax
    raining = false
    needUmbrella = itrue.iif(raining)
    fmt.Printf("Is it raining? %t. Do I need an umbrella? %t\n", raining, needUmbrella)
}
