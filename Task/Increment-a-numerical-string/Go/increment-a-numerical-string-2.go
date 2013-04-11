package main

import (
    "big"
    "fmt"
    "strconv"
)

func main() {
    // integer
    is := "1234"
    fmt.Println("original:   ", is)
    i, err := strconv.Atoi(is)
    if err != nil {
        fmt.Println(err)
        return
    }
    // assignment back to original variable shows result is the same type.
    is = strconv.Itoa(i + 1)
    fmt.Println("incremented:", is)

    // error checking worthwhile
    fmt.Println()
    _, err = strconv.Atoi(" 1234") // whitespace not allowed
    fmt.Println(err)
    _, err = strconv.Atoi("12345678901")
    fmt.Println(err)
    _, err = strconv.Atoi("_1234")
    fmt.Println(err)
    _, err = strconv.Atof64("12.D34")
    fmt.Println(err)

    // float
    fmt.Println()
    fs := "12.34"
    fmt.Println("original:   ", fs)
    f, err := strconv.Atof64(fs)
    if err != nil {
        fmt.Println(err)
        return
    }
    // various options on Ftoa64 produce different formats.  All are valid
    // input to Atof64, so result format does not have to match original
    // format.  (Matching original format would take a lot of code.)
    fs = strconv.Ftoa64(f+1, 'g', -1)
    fmt.Println("incremented:", fs)
    fs = strconv.Ftoa64(f+1, 'e', 4)
    fmt.Println("what format?", fs)

    // complex
    // strconv package doesn't handle complex types, but fmt does.
    // (fmt can be used on ints and floats too, but strconv is more efficient.)
    fmt.Println()
    cs := "(12+34i)"
    fmt.Println("original:   ", cs)
    var c complex128
    _, err = fmt.Sscan(cs, &c)
    if err != nil {
        fmt.Println(err)
        return
    }
    cs = fmt.Sprint(c + 1)
    fmt.Println("incremented:", cs)

    // big integers have their own functions
    fmt.Println()
    bs := "170141183460469231731687303715884105728"
    fmt.Println("original:   ", bs)
    var b, one big.Int
    _, ok := b.SetString(bs, 10)
    if !ok {
        fmt.Println("big.SetString fail")
        return
    }
    one.SetInt64(1)
    bs = b.Add(&b, &one).String()
    fmt.Println("incremented:", bs)
}
