package main

import (
    "encoding/base64"
    "fmt"
    "io/ioutil"
    "net/http"
)

func main() {
    r, err := http.Get("http://rosettacode.org/favicon.ico")
    if err != nil {
        fmt.Println(err)
        return
    }
    defer r.Body.Close()
    d, err := ioutil.ReadAll(r.Body)
    if err != nil {
        fmt.Println(err)
        return
    }
    fmt.Println(base64.StdEncoding.EncodeToString(d))
}
