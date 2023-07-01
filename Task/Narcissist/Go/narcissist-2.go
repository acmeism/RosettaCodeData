package main

import (
    "bytes"
    "fmt"
    "io/ioutil"
    "os"
)

func main() {
    s := fmt.Sprintf("%s%c%s%c\n", x, 0x60, x, 0x60)
    in, _ := ioutil.ReadAll(os.Stdin)
    if bytes.Equal(in, []byte(s)) {
        fmt.Println("Accept")
    } else {
        fmt.Println("Reject")
    }
}

var x = `package main

import (
    "bytes"
    "fmt"
    "io/ioutil"
    "os"
)

func main() {
    s := fmt.Sprintf("%s%c%s%c\n", x, 0x60, x, 0x60)
    in, _ := ioutil.ReadAll(os.Stdin)
    if bytes.Equal(in, []byte(s)) {
        fmt.Println("Accept")
    } else {
        fmt.Println("Reject")
    }
}

var x = `
