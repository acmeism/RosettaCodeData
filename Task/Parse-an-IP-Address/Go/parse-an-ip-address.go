package main

import (
	"errors"
	"fmt"
	"net"
	"strconv"
	"strings"
)

func ParseIPPort(s string) (ip net.IP, port, space string, err error) {
	ip = net.ParseIP(s)
	if ip == nil {
		var host string
		host, port, err = net.SplitHostPort(s)
		if err != nil {
			return
		}
		if port != "" {
			// This check only makes sense if service names are not allowed
			if _, err = strconv.ParseUint(port, 10, 16); err != nil {
				return
			}
		}
		ip = net.ParseIP(host)
	}
	if ip == nil {
		err = errors.New("invalid address format")
	} else {
		space = "IPv6"
		if ip4 := ip.To4(); ip4 != nil {
			space = "IPv4"
			ip = ip4
		}
	}
	return
}

func main() {
	var testCases = []string{
		"127.0.0.1",
		"127.0.0.1:80",
		"::1",
		"[::1]:80",
		"2605:2700:0:3::4713:93e3",
		"[2605:2700:0:3::4713:93e3]:80",
	}
	max := len("Input")
	for _, addr := range testCases {
		if len(addr) > max {
			max = len(addr)
		}
	}
	fmt.Printf("%-*s  %*s  %-6s %s\n", max, "Input",
		2*net.IPv6len, "Address", "Space", "Port")
	for _, addr := range testCases {
		fmt.Printf("%-*s  ", max, addr)
		ip, port, space, err := ParseIPPort(addr)
		if err != nil {
			fmt.Println(err)
			continue
		}
		fmt.Print(strings.Repeat("  ", net.IPv6len-len(ip)))
		for _, b := range ip {
			fmt.Printf("%02x", b)
		}
		fmt.Printf("  %-6s %s\n", space, port)
	}
}
