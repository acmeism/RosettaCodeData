#include once "X11/Xlib.bi"

Dim As Display Ptr dpy
Dim As Window win
Dim As GC gc
Dim As XEvent ev

dpy = XOpenDisplay(NULL)
win = XCreateSimpleWindow(dpy, XDefaultRootWindow(dpy), 0, 0, 400, 300, 0, 0, 0)
gc = XCreateGC(dpy, win, 0, NULL)
XSelectInput(dpy, win, ExposureMask Or KeyPressMask)
XMapWindow(dpy, win)

While XNextEvent(dpy, @ev) = 0
    If ev.type = Expose Then
        XDrawString(dpy, win, gc, 200, 150, "Hello World", 11)
    EndIf
Wend

XCloseDisplay(dpy)
