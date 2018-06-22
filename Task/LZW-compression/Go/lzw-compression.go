package main

import (
	"fmt"
	"log"
	"strings"
)

// Compress a string to a list of output symbols.
func compress(uncompressed string) []int {
	// Build the dictionary.
	dictSize := 256
	// We actually want a map of []byte -> int but
	// slices are not acceptable map key types.
	dictionary := make(map[string]int, dictSize)
	for i := 0; i < dictSize; i++ {
		// Ugly mess to work around not having a []byte key type.
		// Using `string(i)` would do utf8 encoding for i>127.
		dictionary[string([]byte{byte(i)})] = i
	}

	var result []int
	var w []byte
	for i := 0; i < len(uncompressed); i++ {
		c := uncompressed[i]
		wc := append(w, c)
		if _, ok := dictionary[string(wc)]; ok {
			w = wc
		} else {
			result = append(result, dictionary[string(w)])
			// Add wc to the dictionary.
			dictionary[string(wc)] = dictSize
			dictSize++
			//w = []byte{c}, but re-using wc
			wc[0] = c
			w = wc[:1]
		}
	}

	if len(w) > 0 {
		// Output the code for w.
		result = append(result, dictionary[string(w)])
	}
	return result
}

type BadSymbolError int

func (e BadSymbolError) Error() string {
	return fmt.Sprint("Bad compressed symbol ", int(e))
}

// Decompress a list of output symbols to a string.
func decompress(compressed []int) (string, error) {
	// Build the dictionary.
	dictSize := 256
	dictionary := make(map[int][]byte, dictSize)
	for i := 0; i < dictSize; i++ {
		dictionary[i] = []byte{byte(i)}
	}

	var result strings.Builder
	var w []byte
	for _, k := range compressed {
		var entry []byte
		if x, ok := dictionary[k]; ok {
			//entry = x, but ensuring any append will make a copy
			entry = x[:len(x):len(x)]
		} else if k == dictSize && len(w) > 0 {
			entry = append(w, w[0])
		} else {
			return result.String(), BadSymbolError(k)
		}
		result.Write(entry)

		if len(w) > 0 {
			// Add w+entry[0] to the dictionary.
			w = append(w, entry[0])
			dictionary[dictSize] = w
			dictSize++
		}
		w = entry
	}
	return result.String(), nil
}

func main() {
	compressed := compress("TOBEORNOTTOBEORTOBEORNOT")
	fmt.Println(compressed)
	decompressed, err := decompress(compressed)
	if err != nil {
		log.Fatal(err)
	}
	fmt.Println(decompressed)
}
