/* simulate_input_keyboard.wren */

import "random" for Random

var KeyPressMask    = 1 << 0
var ShiftMask       = 1 << 0
var ButtonPressMask = 1 << 2
var ExposureMask    = 1 << 15
var KeyPress        = 2
var ButtonPress     = 4
var Expose          = 12
var ClientMessage   = 33

var XK_q            = 0x0071
var XK_Escape       = 0xff1b

foreign class XGC {
    construct default(display, screenNumber) {}
}

// XEvent is a C union, not a struct, so we amalgamate the properties
foreign class XEvent {
    construct new() {}        // creates the union and returns a pointer to it

    foreign eventType         // gets type field, common to all union members

    foreign eventType=(et)    // sets type field

    foreign state=(st)        // sets xkey.state

    foreign keycode           // gets xkey.keycode

    foreign keycode=(kc)      // sets xkey.keycode

    foreign sameScreen=(ss)   // sets xkey.same_screen

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
}

class X {
   foreign static lookupKeysym(keyEvent, index)

   foreign static lookupString(eventStruct, bufferReturn, bytesBuffer, keysymReturn, statusInOut)
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
xd.storeName(w, "Simulate keystrokes")

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

/* event loop */
var e = XEvent.new()
var rand = Random.new()
while (true) {
    xd.nextEvent(e)
    var et = e.eventType
    if (et == Expose) {
        /* draw or redraw the window */
        var msg1 = "Click in the window to generate"
        var msg2 = "a random key press event"
        xd.drawString(w, gc, 10, 20, msg1, msg1.count)
        xd.drawString(w, gc, 10, 35, msg2, msg2.count)
    } else if (et == ButtonPress) {
        System.print("\nButtonPress event received")
        /* manufacture a KeyPress event and send it to the window */
        var e2 = XEvent.new()
        e2.eventType = KeyPress
        e2.state = ShiftMask
        e2.keycode = 24 + rand.int(33)
        e2.sameScreen = true
        xd.sendEvent(w, true, KeyPressMask, e2)
    } else if (et == ClientMessage) {
        /* delete window event */
         if (e.dataL[0] == wmDeleteWindow) break
    } else if (et == KeyPress) {
        /* handle key press */
        System.print("\nKeyPress event received")
        System.print("> Keycode: %(e.keycode)")
        /* exit if q or escape are pressed */
        var keysym = X.lookupKeysym(e, 0)
        if (keysym == XK_q || keysym == XK_Escape) {
            break
        } else {
            var buffer = List.filled(2, 0)
            var nchars = X.lookupString(e, buffer, 2, 0, 0) // don't need the last 2 parameters
            if (nchars == 1) {
                var b = buffer[0]
                if (b < 0) b = 256 + b
                System.print("> Latin-1: %(b)")
                if (b < 32 || (b >= 127 && b < 160)) {
                    System.print("> Key 'control character' pressed")
                } else {
                    System.print("> Key '%(String.fromByte(b))' pressed")
                }
            }
        }
    }
}

xd.destroyWindow(w)

/* close connection to server */
xd.closeDisplay()
