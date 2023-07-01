/* window_creation_x11.wren */

var KeyPressMask = 1 << 0
var ExposureMask = 1 << 15
var KeyPress     = 2
var Expose       = 12

foreign class XGC {
    construct default(display, screenNumber) {}
}

foreign class XEvent {
    construct new() {}

    foreign eventType
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

    foreign fillRectangle(d, gc, x, y, width, height)

    foreign drawString(d, gc, x, y, string, length)
}

var xd = XDisplay.openDisplay("")
if (xd == 0) {
    System.print("Cannot open display.")
    return
}
var s = xd.defaultScreen()
var w = xd.createSimpleWindow(xd.rootWindow(s), 10, 10, 100, 100, 1, xd.blackPixel(s), xd.whitePixel(s))
xd.selectInput(w, ExposureMask | KeyPressMask)
xd.mapWindow(w)
var msg = "Hello, World!"
var e = XEvent.new()
while (true) {
    xd.nextEvent(e)
    var gc = XGC.default(xd, s)
    if (e.eventType == Expose) {
        xd.fillRectangle(w, gc, 20, 20, 10, 10)
        xd.drawString(w, gc, 10, 50, msg, msg.count)
    }
    if (e.eventType == KeyPress) break
}
xd.closeDisplay()
