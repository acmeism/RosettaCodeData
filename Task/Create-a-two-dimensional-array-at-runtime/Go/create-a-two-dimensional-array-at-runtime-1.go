package main

import "fmt"

func main() {
    var row, col int
    fmt.Print("enter rows cols: ")
    fmt.Scan(&row, &col)

    // allocate composed 2d array
    a := make([][]int, row)
    for i := range a {
        a[i] = make([]int, col)
    }

    // array elements initialized to 0
    fmt.Println("a[0][0] =", a[0][0])

    // assign
    a[row-1][col-1] = 7

    // retrieve
    fmt.Printf("a[%d][%d] = %d\n", row-1, col-1, a[row-1][col-1])

    // remove only reference
    a = nil
    // memory allocated earlier with make can now be garbage collected.
}
