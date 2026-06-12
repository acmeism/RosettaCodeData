package main

import (
	"bufio"
	"fmt"
	"io"
	"log"
	"os"
)

func main() {
	// Often we'd already have wrapped os.Stdin (or some other
	// io.Reader, like an *os.File) in a bufio.Reader by this point
	// and we'd use fmt.Fscanln() on that reader instead.
	var lines int
	n, err := fmt.Scanln(&lines)
	if n != 1 || err != nil {
		log.Fatal(err)
	}

	// Use a bufio.Scanner. This uses a SplitFunc which we can choose
	// or provide our own that splits or otherwise pre-processes the
	// input into tokens however we like.
	//
	// Could also just use bufio.ReadString('\n') but a Scanner
	// with ScanLines matches (and removes) `\r?\n$` and is more
	// general purpose.
	//
	// Normally the loop would be just:
	//	for scanner.Scan() {
	//		// use scanner.Text() or scanner.Bytes()
	//	}
	// and we'd loop until the scan indicated EOF. But for this task
	// we've got an explictly specified number of lines to read.

	scanner := bufio.NewScanner(os.Stdin)
	scanner.Split(bufio.ScanLines) // not needed, this is the default
	for ; scanner.Scan() && lines > 0; lines-- {
		doStuff(scanner.Text())
	}
	if err := scanner.Err(); err != nil {
		log.Fatal(err)
	}
	// Check for too few lines, normally not needed
	if lines > 0 {
		log.Fatalln("early", io.EOF)
	}
}

func doStuff(line string) {
	fmt.Println(line)
}
