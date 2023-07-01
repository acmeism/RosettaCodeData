package main

import (
	"encoding/hex"
	"fmt"
	"io"
	"net"
	"os"
	"strconv"
	"strings"
	"text/tabwriter"
)

// parseIPPort parses an IP with an optional port, returning an IP and a port (or nil
// if no port was present in the given address).
func parseIPPort(address string) (net.IP, *uint64, error) {
	ip := net.ParseIP(address)
	if ip != nil {
		return ip, nil, nil
	}

	host, portStr, err := net.SplitHostPort(address)
	if err != nil {
		return nil, nil, fmt.Errorf("splithostport failed: %w", err)
	}

	port, err := strconv.ParseUint(portStr, 10, 16)
	if err != nil {
		return nil, nil, fmt.Errorf("failed to parse port: %w", err)
	}

	ip = net.ParseIP(host)
	if ip == nil {
		return nil, nil, fmt.Errorf("failed to parse ip address")
	}

	return ip, &port, nil
}

func ipVersion(ip net.IP) int {
	if ip.To4() == nil {
		return 6
	}

	return 4
}

func main() {
	testCases := []string{
		"127.0.0.1",
		"127.0.0.1:80",
		"::1",
		"[::1]:443",
		"2605:2700:0:3::4713:93e3",
		"[2605:2700:0:3::4713:93e3]:80",
	}

	w := tabwriter.NewWriter(os.Stdout, 0, 0, 2, ' ', 0)

	writeTSV := func(w io.Writer, args ...interface{}) {
		fmt.Fprintf(w, strings.Repeat("%s\t", len(args)), args...)
		fmt.Fprintf(w, "\n")
	}

	writeTSV(w, "Input", "Address", "Space", "Port")

	for _, addr := range testCases {
		ip, port, err := parseIPPort(addr)
		if err != nil {
			panic(err)
		}

		portStr := "n/a"
		if port != nil {
			portStr = fmt.Sprint(*port)
		}

		ipVersion := fmt.Sprintf("IPv%d", ipVersion(ip))

		writeTSV(w, addr, hex.EncodeToString(ip), ipVersion, portStr)
	}

	w.Flush()
}
