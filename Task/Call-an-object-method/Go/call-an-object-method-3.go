package main

import "box"

func main() {
    // Call constructor.  Technically it's just an exported function,
    // but it's a Go idiom to naming a function New that serves the purpose
    // of a constructor.
    b := box.New()

    // Call instance method.  In Go terms, simply a method.
    b.TellSecret()

    // Call class method.  In Go terms, another exported function.
    box.Count()
}
