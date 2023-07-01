package main

import (
    "fmt"

    "golang.org/x/net/context"
    "google.golang.org/grpc"
    "google.golang.org/grpc/grpclog"

    "taxcomputer"
)

func main() {
    conn, err := grpc.Dial("localhost:1234", grpc.WithInsecure())
    if err != nil {
        grpclog.Fatalf(err.Error())
    }
    defer conn.Close()
    client := taxcomputer.NewTaxComputerClient(conn)
    amt := &taxcomputer.Amount{300}
    tax, err := client.Tax(context.Background(), amt)
    if err != nil {
        grpclog.Fatalf(err.Error())
    }
    fmt.Println("Tax on", amt.Cents, "cents is", tax.Cents, "cents")
}
