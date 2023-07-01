package require xlib

XOpenDisplay {}
set w [XCreateSimpleWindow 10 10 100 100 1]
XMapWindow $w
while {[lindex [XNextEvent] 0] == "expose"} {
    XFillRectangle $w 20 20 10 10
    XDrawString $w 10 50 "Hello, World!"
}
XDestroyWindow $w
XCloseDisplay
