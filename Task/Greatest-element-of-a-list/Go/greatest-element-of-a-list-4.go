package main

import (
    "fmt"
    "math"
    "math/rand"
    "time"
)

// Function, per task description.  Interesting with the float64 type because
// of the NaN value.  NaNs do not compare to other values, so the result of
// a "largest" function on a set containing a NaN might be open to
// interpretation.  The solution provided here is to return the largest
// of the non-NaNs, and also return a bool indicating the presense of a NaN.
func largest(s map[float64]bool) (lg float64, ok, nan bool) {
    if len(s) == 0 {
        return
    }
    for e := range s {
        switch {
        case math.IsNaN(e):
            nan = true
        case !ok || e > lg:
            lg = e
            ok = true
        }
    }
    return
}

func main() {
    rand.Seed(time.Now().UnixNano())
    // taking "set" literally from task description
    s := map[float64]bool{}
    // pick number of elements to add to set
    n := rand.Intn(11)
    // add random numbers, also throw in an occasional NaN or Inf.
    for i := 0; i < n; i++ {
        switch rand.Intn(10) {
        case 0:
            s[math.NaN()] = true
        case 1:
            s[math.Inf(1)] = true
        default:
            s[rand.ExpFloat64()] = true
        }
    }

    fmt.Print("s:")
    for e := range s {
        fmt.Print(" ", e)
    }
    fmt.Println()
    switch lg, ok, nan := largest(s); {
    case ok && !nan:
        fmt.Println("largest:", lg)
    case ok:
        fmt.Println("largest:", lg, "(NaN present in data)")
    case nan:
        fmt.Println("no largest, all data NaN")
    default:
        fmt.Println("no largest, empty set")
    }
}
