package main

import "fmt"

func main() {
    // labels loop and y both in scope of main
loop:
    for false {
        continue loop
    }
    goto y
y:
    y := 0 // variable namespace is separate from label namespace

    func() {
        // goto loop ...loop not visible from this literal

        // label y in outer scope not visible so it's okay to define a label y
        // here too.
    y:
        for {
            break y
        }
        y++ // regular lexical scoping applies to variables.
    }()
    fmt.Println(y)
}

// end: // labels not allowed outside function blocks
