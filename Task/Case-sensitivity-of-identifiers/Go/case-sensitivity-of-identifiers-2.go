package main

import (
    . "dogs"
    "fmt"
)

func main() {
    // with the dogs package imported, there are three dogs.
    d := PackageSees()
    fmt.Println("There are", len(d), "dogs.\n")

    // Declaration of new variable dog.  It lives in this package, main.
    dog := "Benjamin"
    d = PackageSees()
    fmt.Println("Main sees:   ", dog, Dog, DOG)
    // Four dogs now.  two of the three visible from here are the
    // the same as ones in the dogs package.
    d[&dog] = 1
    d[&Dog] = 1
    d[&DOG] = 1
    fmt.Println("There are", len(d), "dogs.\n")

    // Not a declaration, just an assigment.  This assigns a new value to
    // the variable Dog declared in the package.  Dog is visible because
    // it begins with an upper case letter.
    Dog = "Samba"
    // same four dogs, same three visible, one just has a new name.
    d = PackageSees()
    fmt.Println("Main sees:   ", dog, Dog, DOG)
    d[&dog] = 1
    d[&Dog] = 1
    d[&DOG] = 1
    fmt.Println("There are", len(d), "dogs.\n")

    // Of course you can still declare a variable if you want to.  This
    // declares a new variable, shadowing DOG in the package and rendering
    // it inaccessable even though it begins with an upper case letter.
    var DOG = "Bernie"
    // five dogs now.  three visible from here.
    d = PackageSees()
    fmt.Println("Main sees:   ", dog, Dog, DOG)
    d[&dog] = 1
    d[&Dog] = 1
    d[&DOG] = 1
    fmt.Println("There are", len(d), "dogs.")
}
