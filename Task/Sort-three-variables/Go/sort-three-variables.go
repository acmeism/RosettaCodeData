package main

import (
    "fmt"
    "log"
    "sort"
)

var (
    stringsIn = []string{
        `lions, tigers, and`,
        `bears, oh my!`,
        `(from the "Wizard of OZ")`}
    intsIn = []int{77444, -12, 0}
)

func main() {
    {
        // initialize three vars
        x, y, z := stringsIn[0], stringsIn[1], stringsIn[2]

        // I. Task suggested technique, move values to array (slice).
        // It's consise and relies on library code.
        s := []string{x, y, z}
        sort.Strings(s)
        x, y, z = s[0], s[1], s[2]

        // validate
        if x > y || y > z {
            log.Fatal()
        }

        // II. Likely fastest technique, minimizing tests and data movement.
        // Least consise though, hardest to understand, and most chance to make
        // a coding mistake.
        x, y, z = stringsIn[0], stringsIn[1], stringsIn[2] // (initialize)
        if x < y {
            switch {
            case y < z:
            case x < z:
                y, z = z, y
            default:
                x, y, z = z, x, y
            }
        } else {
            switch {
            case x < z:
                x, y = y, x
            case z < y:
                x, z = z, x
            default:
                x, y, z = y, z, x
            }
        }
        if x > y || y > z { // (validate)
            log.Fatal()
        }

        // III.  A little more consise than II, easier to understand, almost
        // as fast.
        x, y, z = stringsIn[0], stringsIn[1], stringsIn[2] // (initialize)
        if x > y {
            x, y = y, x
        }
        if y > z {
            y, z = z, y
        }
        if x > y {
            x, y = y, x
        }
        if x > y || y > z { // (validate)
            log.Fatal()
        }
        fmt.Println("sorted strings:")
        fmt.Println(" ", x)
        fmt.Println(" ", y)
        fmt.Println(" ", z)
        fmt.Println("original data:")
        fmt.Println(" ", stringsIn[0])
        fmt.Println(" ", stringsIn[1])
        fmt.Println(" ", stringsIn[2])
    }
    // same techniques, with integer test case
    {
        // task suggested technique
        x, y, z := intsIn[0], intsIn[1], intsIn[2] // (initialize)
        s := []int{x, y, z}
        sort.Ints(s)
        x, y, z = s[0], s[1], s[2]
        if x > y || y > z { // (validate)
            log.Fatal()
        }

        // minimizing data movement
        x, y, z = intsIn[0], intsIn[1], intsIn[2] // (initialize)
        if x < y {
            switch {
            case y < z:
            case x < z:
                y, z = z, y
            default:
                x, y, z = z, x, y
            }
        } else {
            switch {
            case x < z:
                x, y = y, x
            case z < y:
                x, z = z, x
            default:
                x, y, z = y, z, x
            }
        }
        if x > y || y > z { // (validate)
            log.Fatal()
        }

        // three swaps
        x, y, z = intsIn[0], intsIn[1], intsIn[2] // (initialize)
        if x > y {
            x, y = y, x
        }
        if y > z {
            y, z = z, y
        }
        if x > y {
            x, y = y, x
        }
        if x > y || y > z { // (validate)
            log.Fatal()
        }
        fmt.Println("sorted ints:", x, y, z)
        fmt.Println("original data:", intsIn)
    }
    // To put any of these techniques in a function, a function could just
    // take three values and return them sorted.
    {
        sort3 := func(x, y, z int) (int, int, int) {
            if x > y {
                x, y = y, x
            }
            if y > z {
                y, z = z, y
            }
            if x > y {
                x, y = y, x
            }
            return x, y, z
        }
        x, y, z := intsIn[0], intsIn[1], intsIn[2] // (initialize)
        x, y, z = sort3(x, y, z)
        if x > y || y > z { // (validate)
            log.Fatal()
        }
    }
    // Alternatively, a function could take pointers
    {
        sort3 := func(x, y, z *int) {
            if *x > *y {
                *x, *y = *y, *x
            }
            if *y > *z {
                *y, *z = *z, *y
            }
            if *x > *y {
                *x, *y = *y, *x
            }
        }
        x, y, z := intsIn[0], intsIn[1], intsIn[2] // (initialize)
        sort3(&x, &y, &z)
        if x > y || y > z { // (validate)
            log.Fatal()
        }
    }
}
