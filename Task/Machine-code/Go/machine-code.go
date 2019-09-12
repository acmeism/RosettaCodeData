package main

import "fmt"

/*
#include <stdio.h>
#include <stdlib.h>
#include <sys/mman.h>
#include <string.h>

typedef unsigned char byte;
typedef byte (*mcfunc) (byte, byte);

void runMachineCode(void *buf, byte a, byte b) {
    mcfunc fp = (mcfunc)buf;
    printf("%d\n", fp(a, b));
}
*/
import "C"

func main() {
    code := []byte{
        144, // Align
        144,
        106, 12, // Prepare stack
        184, 7, 0, 0, 0,
        72, 193, 224, 32,
        80,
        139, 68, 36, 4, 3, 68, 36, 8, // Rosetta task code
        76, 137, 227, // Get result
        137, 195,
        72, 193, 227, 4,
        128, 203, 2,
        72, 131, 196, 16, // Clean up stack
        195, // Return
    }
    le := len(code)
    buf := C.mmap(nil, C.size_t(le), C.PROT_READ|C.PROT_WRITE|C.PROT_EXEC,
        C.MAP_PRIVATE|C.MAP_ANON, -1, 0)
    codePtr := C.CBytes(code)
    C.memcpy(buf, codePtr, C.size_t(le))
    var a, b byte = 7, 12
    fmt.Printf("%d + %d = ", a, b)
    C.runMachineCode(buf, C.byte(a), C.byte(b))
    C.munmap(buf, C.size_t(le))
    C.free(codePtr)
}
