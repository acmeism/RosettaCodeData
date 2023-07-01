package main

import (
    "fmt"
    "math/big"
    "strconv"
)

func main() {
    // package strconv:  the most common string to int conversion,
    // base 10 only.
    x, _ := strconv.Atoi("13")
    fmt.Println(x)

    // ParseInt handles arbitrary bases from 2 to 36, and returns
    // a result of the requested size (64 bits shown here.)
    // If the base argument is zero the base is determined by prefix
    // as with math/big below.
    x64, _ := strconv.ParseInt("3c2", 19, 64)
    fmt.Println(x64)

    // package fmt:  allows direct conversion from strings, standard
    // input, or from an io.Reader (file, buffer, etc) to integer types
    // for bases 2, 8, 10, and 16 or to any type that implements the
    // fmt.Scanner interface (e.g. a big.Int).
    // (Fscanf and Scanf are more common for reading from
    // an io.Reader or stdin than Sscanf for reading from strings.)
    fmt.Sscanf("1101", "%b", &x)
    fmt.Println(x)

    fmt.Sscanf("15", "%o", &x)
    fmt.Println(x)

    fmt.Sscanf("13", "%d", &x)
    fmt.Println(x)

    fmt.Sscanf("d", "%x", &x)
    fmt.Println(x)

    // package math/big:  allows conversion from string to big integer.
    // any base from 2 to 36 can be specified as second parameter.
    var z big.Int
    z.SetString("111", 3)
    fmt.Println(&z)

    // if second parameter is 0, base is determined by prefix, if any
    z.SetString("0b1101", 0) // 0b -> base 2
    fmt.Println(&z)

    z.SetString("015", 0) // 0 -> base 8
    fmt.Println(&z)

    z.SetString("13", 0) // no prefix -> base 10
    fmt.Println(&z)

    z.SetString("0xd", 0) // 0x -> base 16
    fmt.Println(&z)

    // As mentioned, a big.Int (or any type implementing fmt.Scanner)
    // can also be use with any of the fmt scanning functions.
    fmt.Sscanf("15", "%o", &z)
    fmt.Println(&z)
}
