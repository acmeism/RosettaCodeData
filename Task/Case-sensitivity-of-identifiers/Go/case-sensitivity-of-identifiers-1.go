package dogs

import "fmt"

// Three variables, three different names.
// (It wouldn't compile if the compiler saw the variable names as the same.)
var dog = "Salt"
var Dog = "Pepper"
var DOG = "Mustard"

func PackageSees() map[*string]int {
    // Print dogs visible from here.
    fmt.Println("Package sees:", dog, Dog, DOG)
    // Return addresses of the variables visible from here.
    // The point of putting them in a map is that maps store only
    // unique keys, so it will end up with three items only if
    // the variables really represent different places in memory.
    return map[*string]int{&dog: 1, &Dog: 1, &DOG: 1}
}
