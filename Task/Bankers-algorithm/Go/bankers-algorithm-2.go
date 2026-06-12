package main

import (
    "fmt"
    "bank"
)

func main() {
    // Task example data:
    // create "bank" with available resources
    b, _ := bank.New(bank.RMap{"A": 6, "B": 5, "C": 7, "D": 6})

    // add processes with their maximum allocation limits
    b.NewProcess("P1", bank.RMap{"A": 3, "B": 3, "C": 2, "D": 2})
    b.NewProcess("P2", bank.RMap{"A": 1, "B": 2, "C": 3, "D": 4})
    b.NewProcess("P3", bank.RMap{"A": 1, "B": 3, "C": 5})

    // processes request resources.  Each request is checked for safety.
    // <nil> returned error value means request was safe and was granted.
    fmt.Println("P1 request:")
    fmt.Println(b.Request("P1", bank.RMap{"A": 1, "B": 2, "C": 2, "D": 1}))

    fmt.Println("\nP2 request:")
    fmt.Println(b.Request("P2", bank.RMap{"A": 1, "C": 3, "D": 3}))

    fmt.Println("\nP3 request:")
    fmt.Println(b.Request("P3", bank.RMap{"A": 1, "B": 2, "C": 1}))
}
