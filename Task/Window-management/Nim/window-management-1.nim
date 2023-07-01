import os
import gintro/[glib, gobject, gtk, gio]
from gintro/gdk import processAllUpdates

type MyWindow = ref object of ApplicationWindow
  isShifted: bool

#---------------------------------------------------------------------------------------------------

proc wMaximize(button: Button; window: MyWindow) =
  window.maximize()

proc wUnmaximize(button: Button; window: MyWindow) =
  window.unmaximize()

proc wIconify(button: Button; window: MyWindow) =
  window.iconify()

proc wDeiconify(button: Button; window: MyWindow) =
  window.deiconify()

proc wHide(button: Button; window: MyWindow) =
  window.hide()
  processAllUpdates()
  os.sleep(2000)
  window.show()

proc wShow(button: Button; window: MyWindow) =
  window.show()

proc wMove(button: Button; window: MyWindow) =
  var x, y: int
  window.getPosition(x, y)
  if window.isShifted:
    window.move(x - 10, y - 10)
  else:
    window.move(x + 10, y + 10)
  window.isShifted = not window.isShifted

proc wQuit(button: Button; window: MyWindow) =
  window.destroy()

#---------------------------------------------------------------------------------------------------

proc activate(app: Application) =
  ## Activate the application.

  let window = newApplicationWindow(MyWindow, app)
  window.setTitle("Window management")

  let stackBox = newBox(Orientation.vertical, 10)
  stackBox.setHomogeneous(true)

  let
    bMax = newButton("maximize")
    bUnmax = newButton("unmaximize")
    bIcon = newButton("iconize")
    bDeicon = newButton("deiconize")
    bHide = newButton("hide")
    bShow = newButton("show")
    bMove = newButton("move")
    bQuit = newButton("Quit")

  for button in [bMax, bUnmax, bIcon, bDeicon, bHide, bShow, bMove, bQuit]:
    stackBox.add button

  window.setBorderWidth(5)
  window.add(stackBox)

  discard bMax.connect("clicked", wMaximize, window)
  discard bUnmax.connect("clicked", wUnmaximize, window)
  discard bIcon.connect("clicked", wIconify, window)
  discard bDeicon.connect("clicked", wDeiconify, window)
  discard bHide.connect("clicked", wHide, window)
  discard bShow.connect("clicked", wShow, window)
  discard bMove.connect("clicked", wMove, window)
  discard bQuit.connect("clicked", wQuit, window)

  window.showAll()

#———————————————————————————————————————————————————————————————————————————————————————————————————

let app = newApplication(Application, "Rosetta.Window.Management")
discard app.connect("activate", activate)
discard app.run()
