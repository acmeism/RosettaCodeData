package bit

import (
	"bytes"
	"fmt"
	"io"
	"log"
)

func ExampleWriter_WriteBits() {
	var buf bytes.Buffer
	bw := NewWriter(&buf, MSB)
	bw.WriteBits(0x0f, 4) // Writes 1111
	bw.WriteBits(0x00, 1) //        0
	bw.WriteBits(0x13, 5) //        1001 1
	// Close will flush with zero bits, in this case
	//                              0000 00
	if err := bw.Close(); err != nil {
		log.Fatal(err)
	}
	fmt.Printf("%08b", buf.Bytes())
	// Output:
	// [11110100 11000000]
}

func Example() {
	const message = "This is a test."
	fmt.Printf("%q as bytes: % 02[1]X\n", message, []byte(message))
	fmt.Printf("    original bits: %08b\n", []byte(message))

	// Re-write in 7 bit chunks to buf:
	var buf bytes.Buffer
	bw := NewWriter(&buf, MSB)
	for _, r := range message {
		bw.WriteBits(uint16(r), 7) // nolint: errcheck
	}
	if err := bw.Close(); err != nil {
		log.Fatal(err)
	}
	fmt.Printf("Written bitstream: %08b\n", buf.Bytes())
	fmt.Printf("Written bytes: % 02X\n", buf.Bytes())

	// Read back in 7 bit chunks:
	br := NewReader(&buf, MSB)
	var result []byte
	for {
		v, err := br.ReadBits(7)
		if err != nil {
			if err != io.EOF {
				log.Fatal(err)
			}
			break
		}
		if v != 0 {
			result = append(result, byte(v))
		}
	}
	fmt.Printf("Read back as \"%s\"\n", result)
	// Output:
	// "This is a test." as bytes: 54 68 69 73 20 69 73 20 61 20 74 65 73 74 2E
	//     original bits: [01010100 01101000 01101001 01110011 00100000 01101001 01110011 00100000 01100001 00100000 01110100 01100101 01110011 01110100 00101110]
	// Written bitstream: [10101001 10100011 01001111 00110100 00011010 01111001 10100000 11000010 10000011 10100110 01011110 01111101 00010111 00000000]
	// Written bytes: A9 A3 4F 34 1A 79 A0 C2 83 A6 5E 7D 17 00
	// Read back as "This is a test."
}
