package main

import "fmt"

type assoc map[string]interface{}

func merge(base, update assoc) assoc {
    result := make(assoc)
    for k, v := range base {
        result[k] = v
    }
    for k, v := range update {
        result[k] = v
    }
    return result
}

func main() {
    base := assoc{"name": "Rocket Skates", "price": 12.75, "color": "yellow"}
    update := assoc{"price": 15.25, "color": "red", "year": 1974}
    result := merge(base, update)
    fmt.Println(result)
}
