package main

import (
	"bufio"
	"log"
	"os"
)

func main() {
	s := bufio.NewScanner(os.Stdin)
	// Select the split function, other ones are available
	// in bufio or you can provide your own.
	s.Split(bufio.ScanWords)
	for s.Scan() {
		// Get and use the next 'token'
		asBytes := s.Bytes() // Bytes does no alloaction
		asString := s.Text() // Text returns a newly allocated string
		_, _ = asBytes, asString
	}
	if err := s.Err(); err != nil {
		// Handle/report any error (EOF will not be reported)
		log.Fatal(err)
	}
}
