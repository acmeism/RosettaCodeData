package main

import (
    "fmt"
    "log"
    "net/rpc"
)

func main() {
    client, err := rpc.DialHTTP("tcp", "localhost:1234")
    if err != nil {
        fmt.Println(err)
        return
    }

    amount := 3.
    var tax float64
    err = client.Call("TaxComputer.Tax", amount, &tax)
    if err != nil {
        log.Fatal(err)
    }
    fmt.Printf("Tax on %.2f: %.2f\n", amount, tax)
}
