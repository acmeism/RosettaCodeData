package main

import (
	"bufio"
	"fmt"
	"os"
)

func main() {
	stdin := bufio.NewReader(os.Stdin)

	fmt.Println("Please enter an integer: ")

	var i1 int

	for {
		_, err := fmt.Fscan(stdin, &i1)
		if err == nil {
			break
		}
		stdin.ReadString('\n')
		fmt.Println("Sorry, invalid input. Please enter an integer: ")
		flush(stdin)
	}

	fmt.Println(i1)
}

func flush(reader *bufio.Reader) {
	var i2 int
	for i2 = 0; i2 < reader.Buffered(); i2++ {
		reader.ReadByte()
	}
}
