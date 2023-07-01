/* simulate_input_mouse.wren */

var KeyPressMask    = 1 << 0
var ButtonPressMask = 1 << 2
var Button1Mask     = 1 << 8
var ExposureMask    = 1 << 15
var Button1         = 1
var KeyPress        = 2
var ButtonPress     = 4
var Expose          = 12
var ClientMessage   = 33

var XK_a            = 0x0061
var XK_q            = 0x0071
var XK_Escape       = 0xff1b

foreign class XGC {
    construct default(display, screenNumber) {}
}

foreign class XColormap {
    construct default(display, screenNumber) {}
}

foreign class XColor {
    construct new() {}

    foreign pixel
}

// XEvent is a C union, not a struct, so we amalgamate the properties
foreign class XEvent {
    construct new() {}        // creates the union and returns a pointer to it

    foreign eventType         // gets type field, common to all union members

    foreign eventType=(et)    // sets type field

    foreign button            // gets xbutton.button

    foreign button=(b)        // sets xbutton.button

    foreign state=(st)        // sets xbutton.state

    foreign sameScreen=(ss)   // sets xbutton.same_screen

    foreign dataL             // gets xclient.data.l (data is a union)
}

foreign class XDisplay {
    construct openDisplay(displayName) {}

    foreign defaultScreen()

    foreign rootWindow(screenNumber)

    foreign blackPixel(screenNumber)

    foreign whitePixel(screenNumber)

    foreign selectInput(w, eventMask)

    foreign mapWindow(w)

    foreign closeDisplay()

    foreign nextEvent(eventReturn)

    foreign createSimpleWindow(parent, x, y, width, height, borderWidth, border, background)

    foreign drawString(d, gc, x, y, string, length)

    foreign storeName(w, windowName)

    foreign flush()

    foreign internAtom(atomName, onlyIfExists)

    foreign setWMProtocols(w, protocols, count)

    foreign sendEvent(w, propogate, eventMask, eventSend)

    foreign destroyWindow(w)

    foreign parseColor(colormap, spec, exactDefReturn)

    foreign allocColor(colormap, screenInOut)

    foreign setWindowBackground(w, backgroundPixel)

    foreign clearArea(w, x, y, width, height, exposures)
}

class X {
   foreign static lookupKeysym(keyEvent, index)
}

/* open connection with the server */
var xd = XDisplay.openDisplay("")
if (xd == 0) {
    System.print("Cannot open display.")
    return
}
var s = xd.defaultScreen()

/* create window */
var w = xd.createSimpleWindow(xd.rootWindow(s), 10, 10, 350, 250, 1, xd.blackPixel(s), xd.whitePixel(s))
xd.storeName(w, "Simulate mouse press")
var white = true // current background color

/* select kind of events we are interested in */
xd.selectInput(w, ExposureMask | KeyPressMask | ButtonPressMask)

/* map (show) the window */
xd.mapWindow(w)
xd.flush()

/* default graphics context */
var gc = XGC.default(xd, s)

/* connect the close button in the window handle */
var wmDeleteWindow = xd.internAtom("WM_DELETE_WINDOW", true)
xd.setWMProtocols(w, [wmDeleteWindow], 1)

/* create color green */
var green = XColor.new()
var colormap = XColormap.default(xd, s)
xd.parseColor(colormap, "#00FF00", green)
xd.allocColor(colormap, green)

/* event loop */
var e = XEvent.new()
while (true) {
    xd.nextEvent(e)
    var et = e.eventType
    if (et == Expose) {
        /* draw or redraw the window */
        var msg1 = "Press the 'a' key to switch the background color"
        var msg2 = "between white and green."
        xd.drawString(w, gc, 10, 20, msg1, msg1.count)
        xd.drawString(w, gc, 10, 35, msg2, msg2.count)
    } else if (et == ButtonPress) {
        System.write("\nButtonPress event received, ")
        if (white) {
            System.print("switching from white to green")
            xd.setWindowBackground(w, green.pixel)
        } else {
            System.print("switching from green to white")
            xd.setWindowBackground(w, xd.whitePixel(s))
        }
        xd.clearArea(w, 0, 0, 0, 0, true)
        white = !white
    } else if (et == ClientMessage) {
        /* delete window event */
         if (e.dataL[0] == wmDeleteWindow) break
    } else if (et == KeyPress) {
        System.print("\nKeyPress event received")
        /* exit if q or escape are pressed */
        var keysym = X.lookupKeysym(e, 0)
        if (keysym == XK_q || keysym == XK_Escape) {
            break
        } else if (keysym == XK_a) {
            /* if a is pressed, manufacture a ButtonPress event and send it to the window */
            System.print("> Key 'a' pressed, sending ButtonPress event")
            var e2 = XEvent.new()
            e2.eventType = ButtonPress
            e2.state = Button1Mask
            e2.button = Button1
            e2.sameScreen = true
            xd.sendEvent(w, true, ButtonPressMask, e2)
        } else {
            System.print("> Key other than 'a' pressed, not processed")
        }
    }
}

xd.destroyWindow(w)

/* close connection to server */
xd.closeDisplay()
