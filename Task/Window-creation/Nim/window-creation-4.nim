import x11/[xlib, xutil, x]

const
  WINDOW_WIDTH = 400
  WINDOW_HEIGHT = 300

type WindowData = tuple[display: PDisplay; window: Window]

proc createWindow: WindowData =
  let width: cuint = WINDOW_WIDTH
  let height: cuint = WINDOW_HEIGHT
  var sizeHints: XSizeHints

  let display = XOpenDisplay(nil)
  if display == nil:
    echo "Connection to X server failed."
    quit QuitFailure

  let screen = XDefaultScreen(display)
  var rootwin = XRootWindow(display, screen)
  let win = XCreateSimpleWindow(display, rootwin, 100, 10, width, height, 5,
                                XBlackPixel(display, screen), XWhitePixel(display, screen))
  sizeHints.flags = PSize or PMinSize or PMaxSize
  sizeHints.min_width = width.cint
  sizeHints.max_width = width.cint
  sizeHints.min_height = height.cint
  sizeHints.max_height = height.cint
  discard XSetStandardProperties(
          display, win, "Simple Window", "window", 0, nil, 0, addr(sizeHints))
  discard XSelectInput(display, win, ButtonPressMask or KeyPressMask or PointerMotionMask)
  discard XMapWindow(display, win)
  result = (display, win)

proc closeWindow(data: WindowData) =
  discard XDestroyWindow(data.display, data.window)
  discard XCloseDisplay(data.display)

proc processEvent(xev: var XEvent) =
  var key: KeySym
  case xev.theType.int
  of KeyPress:
    key = XLookupKeysym(cast[ptr XKeyEvent](addr(xev)), 0)
    if key.int != 0:
      echo "keyboard event ", key.int
    if key.int == 65307:    # <Esc>
      quit QuitSuccess
  of ButtonPressMask, PointerMotionMask:
    echo "Mouse event"
  else:
    discard

proc eventloop(data: WindowData) =
  var xev: XEvent
  discard XFlush(data.display)
  var numEvents = XPending(data.display).int
  while numEvents != 0:
    dec numEvents
    discard XNextEvent(data.display, addr(xev))
    processEvent(xev)

let windata = createWindow()
while true:
  eventloop(windata)
windata.closeWindow()
