package provide xlib 1
package require critcl

critcl::clibraries -L/usr/X11/lib -lX11
critcl::ccode {
    #include <X11/Xlib.h>
    static Display *d;
    static GC gc;
}

# Display connection functions
critcl::cproc XOpenDisplay {Tcl_Interp* interp char* name} ok {
    d = XOpenDisplay(name[0] ? name : NULL);
    if (d == NULL) {
	Tcl_AppendResult(interp, "cannot open display", NULL);
	return TCL_ERROR;
    }
    gc = DefaultGC(d, DefaultScreen(d));
    return TCL_OK;
}
critcl::cproc XCloseDisplay {} void {
    XCloseDisplay(d);
}

# Basic window functions
critcl::cproc XCreateSimpleWindow {
    int x  int y  int width  int height  int events
} int {
    int s = DefaultScreen(d);
    Window w = XCreateSimpleWindow(d, RootWindow(d,s), x, y, width, height, 0,
	    BlackPixel(d,s), WhitePixel(d,s));
    XSelectInput(d, w, ExposureMask | events);
    return (int) w;
}
critcl::cproc XDestroyWindow {int w} void {
    XDestroyWindow(d, (Window) w);
}
critcl::cproc XMapWindow {int w} void {
    XMapWindow(d, (Window) w);
}
critcl::cproc XUnmapWindow {int w} void {
    XUnmapWindow(d, (Window) w);
}

# Event receiver
critcl::cproc XNextEvent {Tcl_Interp* interp} char* {
    XEvent e;
    XNextEvent(d, &e);
    switch (e.type) {
	case Expose:	return "type expose";
	case KeyPress:	return "type key";
	/* etc. This is a cheap hack version. */
	default:	return "type ?";
    }
}

# Painting functions
critcl::cproc XFillRectangle {int w int x int y int width int height} void {
    XFillRectangle(d, (Window)w, gc, x, y, width, height);
}
critcl::cproc XDrawString {int w int x int y Tcl_Obj* msg} void {
    int len;
    const char *str = Tcl_GetStringFromObj(msg, &len);
    XDrawString(d, (Window)w, gc, x, y, str, len);
}
