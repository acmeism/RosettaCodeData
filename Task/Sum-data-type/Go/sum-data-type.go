package main

import (
    "errors"
    "fmt"
)

type (
    IpAddr struct{ v interface{} }
    Ipv4   = [4]uint8
    Ipv6   = string
)

var zero = Ipv4{}

func NewIpAddr(v interface{}) (*IpAddr, error) {
    switch v.(type) {
    case Ipv4, Ipv6:
        return &IpAddr{v}, nil
    default:
        err := errors.New("Type of value must either be Ipv4 or Ipv6.")
        return nil, err
    }
}

func (ip *IpAddr) V4() (Ipv4, error) {
    switch ip.v.(type) {
    case Ipv4:
        return ip.v.(Ipv4), nil
    default:
        err := errors.New("IpAddr instance doesn't currently hold an Ipv4.")
        return zero, err
    }
}

func (ip *IpAddr) SetV4(v Ipv4) {
    ip.v = v
}

func (ip *IpAddr) V6() (Ipv6, error) {
    switch ip.v.(type) {
    case Ipv6:
        return ip.v.(Ipv6), nil
    default:
        err := errors.New("IpAddr instance doesn't currently hold an Ipv6.")
        return "", err
    }
}

func (ip *IpAddr) SetV6(v Ipv6) {
    ip.v = v
}

func check(err error) {
    if err != nil {
        fmt.Println(err)
    }
}

func main() {
    v4 := Ipv4{127, 0, 0, 1}
    ip, _ := NewIpAddr(v4)
    home, _ := ip.V4()
    fmt.Println(home)
    v6 := "::1"
    ip.SetV6(v6)
    loopback, _ := ip.V6()
    fmt.Println(loopback)
    _, err := ip.V4()
    check(err)
    rubbish := 6
    ip, err = NewIpAddr(rubbish)
    check(err)
}
