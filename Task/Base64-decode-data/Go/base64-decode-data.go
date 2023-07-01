package main

import (
    "encoding/base64"
    "fmt"
)

func main() {
    msg := "Rosetta Code Base64 decode data task"
    fmt.Println("Original :", msg)
    encoded := base64.StdEncoding.EncodeToString([]byte(msg))
    fmt.Println("\nEncoded  :", encoded)
    decoded, err := base64.StdEncoding.DecodeString(encoded)
    if err != nil {
        fmt.Println(err)
        return
    }
    fmt.Println("\nDecoded  :", string(decoded))
}
