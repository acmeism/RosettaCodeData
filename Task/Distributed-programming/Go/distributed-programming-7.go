package main

import (
    "errors"
    "log"

    "git.apache.org/thrift.git/lib/go/thrift"

    "gen-go/tax"
)

type taxHandler float64

func (r taxHandler) Tax(amt int32) (int32, error) {
    if amt < 0 {
        return 0, errors.New("Negative amounts not allowed")
    }
    return int32(float64(amt)*float64(r) + .5), nil
}

func main() {
    transport, err := thrift.NewTServerSocket("localhost:3141")
    if err != nil {
        log.Fatal(err)
    }
    transFac := thrift.NewTTransportFactory()
    protoFac := thrift.NewTCompactProtocolFactory()
    proc := tax.NewTaxServiceProcessor(taxHandler(.05))
    s := thrift.NewTSimpleServer4(proc, transport, transFac, protoFac)
    if err := s.Serve(); err != nil {
        log.Fatal(err)
    }
}
