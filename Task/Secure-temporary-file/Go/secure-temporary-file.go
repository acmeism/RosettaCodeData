package main

import (
	"fmt"
	"io/ioutil"
	"log"
	"os"
)

func main() {
	f, err := ioutil.TempFile("", "foo")
	if err != nil {
		log.Fatal(err)
	}
	defer f.Close()

	// We need to make sure we remove the file
	// once it is no longer needed.
	defer os.Remove(f.Name())

	// … use the file via 'f' …
	fmt.Fprintln(f, "Using temporary file:", f.Name())
	f.Seek(0, 0)
	d, err := ioutil.ReadAll(f)
	if err != nil {
		log.Fatal(err)
	}
	fmt.Printf("Wrote and read: %s\n", d)

        // The defer statements above will close and remove the
        // temporary file here (or on any return of this function).
}
