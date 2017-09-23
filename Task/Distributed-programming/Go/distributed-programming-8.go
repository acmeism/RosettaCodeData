package main

import (
    "fmt"
    "log"

    "git.apache.org/thrift.git/lib/go/thrift"

    "gen-go/tax"
)

func main() {
    transport, err := thrift.NewTSocket("localhost:3141")
    if err != nil {
        log.Fatal(err)
    }
    if err := transport.Open(); err != nil {
        log.Fatal(err)
    }
    protoFac := thrift.NewTCompactProtocolFactory()
    client := tax.NewTaxServiceClientFactory(transport, protoFac)
    amt := int32(300)
    t, err := client.Tax(amt)
    if err != nil {
        log.Print(err)
    } else {
        fmt.Println("tax on", amt, "is", t)
    }
    transport.Close()
}
