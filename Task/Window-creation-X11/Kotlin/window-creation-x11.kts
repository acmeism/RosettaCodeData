// Kotlin Native v0.3

import kotlinx.cinterop.*
import Xlib.*

fun main(args: Array<String>) {
    val msg = "Hello, World!"
    val d = XOpenDisplay(null)
    if (d == null) {
        println("Cannot open display")
        return
    }

    val s = XDefaultScreen(d)
    val w = XCreateSimpleWindow(d, XRootWindow(d, s), 10, 10, 160, 160, 1,
                                XBlackPixel(d, s), XWhitePixel(d, s))
    XSelectInput(d, w, ExposureMask or KeyPressMask)
    XMapWindow(d, w)
    val e = nativeHeap.alloc<XEvent>()

    while (true) {
        XNextEvent(d, e.ptr)
        if (e.type == Expose) {
            XFillRectangle(d, w, XDefaultGC(d, s), 55, 40, 50, 50)
            XDrawString(d, w, XDefaultGC(d, s), 45, 120, msg, msg.length)
        }
        else if (e.type == KeyPress) break
    }

    XCloseDisplay(d)
    nativeHeap.free(e)
}
