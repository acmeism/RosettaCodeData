package main

/*
#cgo LDFLAGS: -lX11
#include <stdlib.h>
#include <X11/Xlib.h>
#include <X11/keysym.h>

static inline Window DefaultRootWindow_macro(Display *dpy) {
    return ScreenOfDisplay(dpy, DefaultScreen(dpy))->root;
}

static inline int getXEvent_type(XEvent event) {
    return event.type;
}

static inline XKeyEvent getXEvent_xkey(XEvent event) {
    return event.xkey;
}
*/
import "C"
import "fmt"
import "unsafe"

func main() {
    d := C.XOpenDisplay(nil)
    f7, f6 := C.CString("F7"), C.CString("F6")
    defer C.free(unsafe.Pointer(f7))
    defer C.free(unsafe.Pointer(f6))

    if d != nil {
        C.XGrabKey(d, C.int(C.XKeysymToKeycode(d, C.XStringToKeysym(f7))),
            C.Mod1Mask, /* normally it's Alt */
            C.DefaultRootWindow_macro(d), C.True, C.GrabModeAsync, C.GrabModeAsync)
        C.XGrabKey(d, C.int(C.XKeysymToKeycode(d, C.XStringToKeysym(f6))),
            C.Mod1Mask,
            C.DefaultRootWindow_macro(d), C.True, C.GrabModeAsync, C.GrabModeAsync)

        var event C.XEvent
        for {
            C.XNextEvent(d, &event)
            if C.getXEvent_type(event) == C.KeyPress {
                xkeyEvent := C.getXEvent_xkey(event)
                s := C.XLookupKeysym(&xkeyEvent, 0)
                if s == C.XK_F7 {
                    fmt.Println("something's happened")
                } else if s == C.XK_F6 {
                    break
                }
            }
        }

        C.XUngrabKey(d, C.int(C.XKeysymToKeycode(d, C.XStringToKeysym(f7))), C.Mod1Mask, C.DefaultRootWindow_macro(d))
        C.XUngrabKey(d, C.int(C.XKeysymToKeycode(d, C.XStringToKeysym(f6))), C.Mod1Mask, C.DefaultRootWindow_macro(d))
    } else {
        fmt.Println("XOpenDisplay did not succeed")
    }
}
