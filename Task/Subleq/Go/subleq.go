package main

import (
	"io"
	"log"
	"os"
)

func main() {
	var mem = []int{
		15, 17, -1, 17, -1, -1, 16, 1, -1, 16, 3, -1, 15, 15, 0, 0, -1,
		//'H', 'e', 'l', 'l', 'o', ' ', 'w', 'o', 'r', 'l', 'd', '!', '\n',
		72, 101, 108, 108, 111, 44, 32, 119, 111, 114, 108, 100, 33, 10,
		0,
	}
	for ip := 0; ip >= 0; {
		switch {
		case mem[ip] == -1:
			mem[mem[ip+1]] = readbyte()
		case mem[ip+1] == -1:
			writebyte(mem[mem[ip]])
		default:
			b := mem[ip+1]
			v := mem[b] - mem[mem[ip]]
			mem[b] = v
			if v <= 0 {
				ip = mem[ip+2]
				continue
			}
		}
		ip += 3
	}
}

func readbyte() int {
	var b [1]byte
	if _, err := io.ReadFull(os.Stdin, b[:]); err != nil {
		log.Fatalln("read:", err)
	}
	return int(b[0])
}

func writebyte(b int) {
	if _, err := os.Stdout.Write([]byte{byte(b)}); err != nil {
		log.Fatalln("write:", err)
	}
}
