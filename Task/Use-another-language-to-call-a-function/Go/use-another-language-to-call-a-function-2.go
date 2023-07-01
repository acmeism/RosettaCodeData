package main

// #include <stdlib.h>
// extern void Run();
import "C"
import "unsafe"

func main() {
    C.Run()
}

const msg = "Here am I"

//export Query
func Query(cbuf *C.char, csiz *C.size_t) C.int {
    if int(*csiz) <= len(msg) {
        return 0
    }
    pbuf := uintptr(unsafe.Pointer(cbuf))
    for i := 0; i < len(msg); i++ {
        *((*byte)(unsafe.Pointer(pbuf))) = msg[i]
        pbuf++
    }
    *((*byte)(unsafe.Pointer(pbuf))) = 0
    *csiz = C.size_t(len(msg) + 1)
    return 1
}
