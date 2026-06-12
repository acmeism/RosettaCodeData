package main

import (
	"flag"
	"fmt"
	"io"
	"os"
	"unicode"
)

func dump(offset int, maxLength int, file *os.File, binaryOutput bool) {
	file.Seek(int64(offset), 0)

	readLength := offset

	var format string
	var pad int

	if binaryOutput {
		format = "%08b "
		pad = 9
	} else {
		format = "%02x "
		pad = 3
	}

	for {
		buffer := make([]byte, maxLength)

		n, err := file.Read(buffer)

		if err != nil {
			if err == io.EOF {
				break
			}

			panic(err)
		}

		fmt.Printf("%08x  ", readLength)

		for i := range maxLength {
			v := buffer[i]

			if i >= n {
				fmt.Printf("%*s", pad, "")
			} else {
				fmt.Printf(format, v)
			}

			if i == 7 && maxLength != 8 {
				fmt.Print(" ")
			}
		}

		fmt.Print("  ")
		fmt.Print("|")

		for i, v := range buffer {
			if i >= n {
				break
			}

			r := rune(v)
			if r >= unicode.MaxASCII || unicode.IsControl(r) {
				fmt.Print(".")
			} else {
				fmt.Print(string(v))
			}
		}
		fmt.Println("|")
		readLength += n
	}
	fmt.Printf("%08x\n", readLength)
}

func main() {
	binary := flag.Bool("binary", false, "Dump in binary mode")
	offset := flag.Int("offset", 0, "Specify starting offset")
	length := flag.Int("length", 16, "Specify read length")

	flag.Parse()

	if *length > 16 {
		panic("Max read length is 16")
	}

	file := flag.Arg(0)

	if file == "" {
		panic("Missing file argument!")
	}

	fp, err := os.Open(file)

	if err != nil {
		panic(err)
	}

	dump(*offset, *length, fp, *binary)
}
