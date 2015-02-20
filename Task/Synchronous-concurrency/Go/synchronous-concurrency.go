package main

import (
	"bufio"
	"fmt"
	"io"
	"os"
)

// main, one of two goroutines used, will function as the "reading unit"
func main() {
	// get file open first
	f, err := os.Open("input.txt")
	if err != nil {
		fmt.Println(err)
		return
	}
	defer f.Close()
	lr := bufio.NewReader(f)

	// that went ok, now create communication channels,
	// and start second goroutine as the "printing unit"
	lines := make(chan string)
	count := make(chan int)
	go printer(lines, count)

	for {
		switch line, err := lr.ReadString('\n'); err {
		case nil:
			lines <- line
			continue
		case io.EOF:
		default:
			fmt.Println(err)
		}
		break
	}

	// this represents the request for the printer to send the count
	close(lines)
	// wait for the count from the printer, then print it, then exit
	fmt.Println("Number of lines:", <-count)
}

func printer(in <-chan string, count chan<- int) {
	c := 0
	// loop as long as in channel stays open
	for s := range in {
		fmt.Print(s)
		c++
	}
	// make count available on count channel, then return (terminate goroutine)
	count <- c
}
