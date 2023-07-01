// Example of composition of anonymous structs
package main

import "fmt"

// Two ordinary structs
type camera struct {
    optics, sensor string
}

type mobilePhone struct {
    sim, firmware string
}

// Fields are anonymous because only the type is listed.
// Also called an embedded field.
type cameraPhone struct {
    camera
    mobilePhone
}

func main() {
    // Struct literals must still reflect the nested structure
    htc := cameraPhone{camera{optics: "zoom"}, mobilePhone{firmware: "3.14"}}

    // But fields of anonymous structs can be referenced without qualification.
    // This provides some effect of the two parent structs being merged, as
    // with multiple inheritance in some other programming languages.
    htc.sim = "XYZ"
    fmt.Println(htc)
}
