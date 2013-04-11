// Example of composition of interfaces.
// Types implement interfaces simply by implementing functions.
// The type does not explicitly declare the interfaces it implements.
package main

import "fmt"

// Two interfaces.
type camera interface {
    photo()
}

type mobilePhone interface {
    call()
}

// Compose interfaces.  cameraPhone interface now contains whatever
// methods are in camera and mobilePhone.
type cameraPhone interface {
    camera
    mobilePhone
}

// User defined type.
type htc int

// Once the htc type has this method defined on it, it automatically satisfies
// the camera interface.
func (htc) photo() {
    fmt.Println("snap")
}

// And then with this additional method defined, it now satisfies both the
// mobilePhone and cameraPhone interfaces.
func (htc) call() {
    fmt.Println("omg!")
}

func main() {
    // type of i is the composed interface.  The assignment only compiles
    // because static type htc satisfies the interface cameraPhone.
    var i cameraPhone = new(htc)
    // interface functions can be called without reference to the
    // underlying type.
    i.photo()
    i.call()
}
