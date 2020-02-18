package main

/*
#cgo LDFLAGS: -ldl

#include <stdlib.h>
#include <dlfcn.h>

typedef int (*someFunc) (const char *s);

int bridge_someFunc(someFunc f, const char *s) {
    return f(s);
}
*/
import "C"
import (
    "fmt"
    "os"
    "unsafe"
)

var handle = -1

func myOpenImage(s string) int {
    fmt.Fprintf(os.Stderr, "internal openImage opens %s...\n", s)
    handle++
    return handle
}

func main() {
    libpath := C.CString("./fakeimglib.so")
    defer C.free(unsafe.Pointer(libpath))
    imglib := C.dlopen(libpath, C.RTLD_LAZY)
    var imghandle int
    if imglib != nil {
        openimage := C.CString("openimage")
        defer C.free(unsafe.Pointer(openimage))
        fp := C.dlsym(imglib, openimage)
        if fp != nil {
            fi := C.CString("fake.img")
            defer C.free(unsafe.Pointer(fi))
            imghandle = int(C.bridge_someFunc(C.someFunc(fp), fi))

        } else {
            imghandle = myOpenImage("fake.img")
        }
        C.dlclose(imglib)
    } else {
        imghandle = myOpenImage("fake.img")
    }
    fmt.Printf("opened with handle %d\n", imghandle)
}
