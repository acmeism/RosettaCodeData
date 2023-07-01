package main

import (
    "errors"
    "net"

    "golang.org/x/net/context"
    "google.golang.org/grpc"
    "google.golang.org/grpc/grpclog"

    "taxcomputer"
)

type taxServer struct {
    rate float64
}

func (s *taxServer) Tax(ctx context.Context,
    amt *taxcomputer.Amount) (*taxcomputer.Amount, error) {
    if amt.Cents < 0 {
        return nil, errors.New("Negative amounts not allowed")
    }
    return &taxcomputer.Amount{int32(float64(amt.Cents)*s.rate + .5)}, nil
}

func main() {
    listener, err := net.Listen("tcp", ":1234")
    if err != nil {
        grpclog.Fatalf(err.Error())
    }
    grpcServer := grpc.NewServer()
    taxcomputer.RegisterTaxComputerServer(grpcServer, &taxServer{.05})
    grpcServer.Serve(listener)
}
