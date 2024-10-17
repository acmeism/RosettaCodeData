using Xlib

function x11demo()
    # Open connection to the server.
    dpy = XOpenDisplay(C_NULL)
    dpy == C_NULL && error("unable to open display")
    scr = DefaultScreen(dpy)

    # Create a window.
    win = XCreateSimpleWindow(dpy, RootWindow(dpy, scr), 10, 10, 300, 100, 1,
                              BlackPixel(dpy, scr), WhitePixel(dpy, scr))

    # Select the kind of events we are interested in.
    XSelectInput(dpy, win, ExposureMask | KeyPressMask)

    # Show or in x11 terms map window.
    XMapWindow(dpy, win)

    # Run event loop.
    evt = Ref(XEvent())
    while true
        XNextEvent(dpy, evt)

        # Draw or redraw the window.
        if EventType(evt) == Expose
            XFillRectangle(dpy, win, DefaultGC(dpy, scr), 24, 24, 16, 16)
            XDrawString(dpy, win, DefaultGC(dpy, scr), 50, 50, "Hello, World! Press any key to exit.")
        end

        # Exit whenever a key is pressed.
        if EventType(evt) == KeyPress
            break
        end
    end

    # Shutdown server connection
    XCloseDisplay(dpy)
end

x11demo()
