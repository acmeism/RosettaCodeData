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
        0x55, 0x48, 0x89, 0xe5, 0x89, 0x7d,
        0xfc, 0x89, 0x75, 0xf8, 0x8b, 0x75,
        0xfc, 0x03, 0x75, 0xf8, 0x89, 0x75,
        0xf4, 0x8b, 0x45, 0xf4, 0x5d, 0xc3,
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
