package main

import "core:fmt"
import "core:net"

MSG: string : "hello socket world"

main :: proc() {
	sock, err := net.dial_tcp("127.0.0.1:256")
	if err != nil do fmt.panicf("Connection failed: %v", err)

	_, err = net.send(sock, transmute([]u8)MSG)
	if err != nil do fmt.panicf("Error sending: %v", err)
}
