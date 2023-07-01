package main

import (
    "bufio"
    "fmt"
    "os"
    "strconv"
    "strings"
)

func main() {
    in := bufio.NewReader(os.Stdin)

    fmt.Print("Enter string: ")
    s, err := in.ReadString('\n')
    if err != nil {
        fmt.Println(err)
        return
    }
    s = strings.TrimSpace(s)

    fmt.Print("Enter 75000: ")
    s, err = in.ReadString('\n')
    if err != nil {
        fmt.Println(err)
        return
    }
    n, err := strconv.Atoi(strings.TrimSpace(s))
    if err != nil {
        fmt.Println(err)
        return
    }
    if n != 75000 {
        fmt.Println("fail:  not 75000")
        return
    }
    fmt.Println("Good")
}
