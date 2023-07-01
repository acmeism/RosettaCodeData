package main

import (
    "errors"
    "log"
    "net"
    "net/http"
    "net/rpc"
)

type TaxComputer float64

func (taxRate TaxComputer) Tax(x float64, r *float64) error {
    if x < 0 {
        return errors.New("Negative values not allowed")
    }
    *r = x * float64(taxRate)
    return nil
}

func main() {
    c := TaxComputer(.05)
    rpc.Register(c)
    rpc.HandleHTTP()
    listener, err := net.Listen("tcp", ":1234")
    if err != nil {
        log.Fatal(err)
    }
    http.Serve(listener, nil)
}
