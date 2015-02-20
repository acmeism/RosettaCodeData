package main

import (
	"bufio"
	"errors"
	"fmt"
	"io"
	"os"
)

func main() {
	if line, err := rsl("input.txt", 7); err == nil {
		fmt.Println("7th line:")
		fmt.Println(line)
	} else {
		fmt.Println("rsl:", err)
	}
}

func rsl(fn string, n int) (string, error) {
	if n < 1 {
		return "", fmt.Errorf("invalid request: line %d", n)
	}
	f, err := os.Open(fn)
	if err != nil {
		return "", err
	}
	defer f.Close()
	bf := bufio.NewReader(f)
	var line string
	for lnum := 0; lnum < n; lnum++ {
		line, err = bf.ReadString('\n')
		if err == io.EOF {
			switch lnum {
			case 0:
				return "", errors.New("no lines in file")
			case 1:
				return "", errors.New("only 1 line")
			default:
				return "", fmt.Errorf("only %d lines", lnum)
			}
		}
		if err != nil {
			return "", err
		}
	}
	if line == "" {
		return "", fmt.Errorf("line %d empty", n)
	}
	return line, nil
}
