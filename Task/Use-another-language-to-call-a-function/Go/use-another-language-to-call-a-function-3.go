// This buildmode requires the package to be main
package main

// Import C so we can export the function to C and use C types

//#include <stdlib.h> // for size_t
import "C"

// Import reflect and unsafe so we can wrap the C array in a Go slice
import "reflect"
import "unsafe"

// This buildmode also requires a main function, but it is never actually called
func main() {}

// The message to copy into the buffer
const msg = "Here am I"

// Here we declare the Query function using C types and export it to C

//export Query
func Query(buffer *C.char, length *C.size_t) C.int {
        // Check there is enough space in the buffer
        if int(*length) < len(msg) {
                return 0
        }

        // Wrap the buffer in a slice to make it easier to copy into
        sliceHeader := reflect.SliceHeader {
                Data: uintptr(unsafe.Pointer(buffer)),
                Len: len(msg),
                Cap: len(msg),
        }
        bufferSlice := *(*[]byte)(unsafe.Pointer(&sliceHeader))

        // Iterate through the message and copy it to the buffer, byte by byte
        for i:=0;i<len(msg);i++ {
                bufferSlice[i] = msg[i]
        }

        // Set length to the amount of bytes we copied
        (*length) = C.size_t(len(msg))

        return 1
}
