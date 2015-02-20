package main

import (
    "fmt"
    "math/big"
    "strconv"
)

func main() {
    // fmt.Print formats integer types directly as bases 2, 8, 10, and 16.
    fmt.Printf("%b\n", 13)
    fmt.Printf("%o\n", 13)
    fmt.Printf("%d\n", 13)
    fmt.Printf("%x\n", 13)
    // big ints work with fmt as well.
    d := big.NewInt(13)
    fmt.Printf("%b\n", d)
    fmt.Printf("%o\n", d)
    fmt.Printf("%d\n", d)
    fmt.Printf("%x\n", d)
    // strconv.FormatInt handles arbitrary bases from 2 to 36 for the
    // int64 type.  There is also strconv.FormatUInt for the uint64 type.
    // There no equivalent for big ints.
    fmt.Println(strconv.FormatInt(1313, 19))
}
