/* keyboard_macros.wren */

var GrabModeAsync = 1
var Mod1Mask      = 1 << 3
var KeyPress      = 2

var XK_F6 = 0xffc3
var XK_F7 = 0xffc4

foreign class XEvent {
    construct new() {}

    foreign eventType
}

foreign class XDisplay {
    construct openDisplay(displayName) {}

    foreign defaultRootWindow()

    foreign grabKey(keycode, modifiers, grabWindow, ownerEvents, pointerMode, keyboardMode)

    foreign ungrabKey(keycode, modifiers, grabWindow)

    foreign keysymToKeycode(keysym)

    foreign closeDisplay()

    foreign nextEvent(eventReturn)
}

class X {
    foreign static stringToKeysym(string)

    foreign static lookupKeysym(keyEvent, index)
}

var xd = XDisplay.openDisplay("")
if (xd == 0) {
    System.print("Cannot open display.")
    return
}
var drw = xd.defaultRootWindow()
xd.grabKey(xd.keysymToKeycode(X.stringToKeysym("F7")), Mod1Mask, drw, true, GrabModeAsync, GrabModeAsync)
xd.grabKey(xd.keysymToKeycode(X.stringToKeysym("F6")), Mod1Mask, drw, true, GrabModeAsync, GrabModeAsync)
var e = XEvent.new()
while (true) {
    xd.nextEvent(e)
    if (e.eventType == KeyPress) {
        var s = X.lookupKeysym(e, 0)
        if (s == XK_F7) {
            System.print("something's happened.")
        } else if (s == XK_F6) {
            break
        }
    }
}
xd.ungrabKey(xd.keysymToKeycode(X.stringToKeysym("F7")), Mod1Mask, drw)
xd.ungrabKey(xd.keysymToKeycode(X.stringToKeysym("F6")), Mod1Mask, drw)
xd.closeDisplay()
