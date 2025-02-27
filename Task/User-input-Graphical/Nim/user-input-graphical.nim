import std/strformat
import gtk2, glib2

###############################################################################
# Missing declaration.

when defined(win32):
  const lib = "libgtk-win32-2.0-0.dll"
elif defined(macosx):
  const lib = "(libgtk-quartz-2.0.0.dylib|libgtk-x11-2.0.dylib)"
else:
  const lib = "libgtk-x11-2.0.so(|.0)"

proc getContentArea(dialog: PDialog): PVBox {.cdecl,
    importc: "gtk_dialog_get_content_area", dynlib: lib.}


###############################################################################

type App = object
  window: PWindow
  strEntry: PEntry
  intEntry: PSpinButton


proc displayValues(app: App; strval: cstring; intval: int) =
  ## Display a dialog window with the values entered by the user.

  let dialog = dialogNewWithButtons("user_input_graphical", app.window,
                                    DIALOG_MODAL or DIALOG_DESTROY_WITH_PARENT, "OK")
  let label1 = labelNew(cstring(&" String value is “{strval}”."))
  let contentArea = dialog.getContentArea()
  contentArea.packStart(label1, true, true, 5)
  let text = if intval == 75000: "right. " else: "wrong (expected 75000). "
  let msg = &" Integer value is {intval} which is {text}"
  let label2 = labelNew(msg.cstring)
  contentArea.packStart(label2, true, true, 5)
  dialog.showAll()
  discard dialog.run()
  dialog.destroy()


proc onOk(button: PButton; app: var App) =
  ## Callback executed when the OK button has been clicked.
  let strval = app.strEntry.getText()
  let intval = app.intEntry.getValue().toInt
  app.displayValues(strval, intval)
  if intval == 75_000:
    app.window.destroy()


proc onDestroyEvent(widget: PWidget; data: pointer): gboolean {.cdecl.} =
  ## Quit the application.
  mainQuit()


var app: App

nimInit()

app.window = windowNew(WINDOW_TOPLEVEL)
app.window.setTitle("User input")
discard app.window.signalConnect("destroy", SIGNAL_FUNC(onDestroyEvent), nil)

let content = vboxNew(false, 10)
content.setHomogeneous(true)
let grid = tableNew(2, 2, false)
grid.setColSpacings(30)

let hbox1 = hboxNew(false, 0)
let strLabel = labelNew("Enter some text")
app.strEntry = entryNew()
hbox1.packStart(strLabel, false, false, 0)
grid.attach(hbox1, 0, 1, 0, 1, constFILL, 0, 0, 0)
grid.attach(app.strEntry, 1, 2, 0, 1, constFILL, 0, 0, 0)

let hbox2 = hboxNew(false, 0)
let intLabel = labelNew("Enter 75000")
app.intEntry = spinButtonNew(0, 80_000, 1)
hbox2.packStart(intLabel, false, false, 0)
grid.attach(hbox2, 0, 1, 1, 2, constFILL, 0, 0, 0)
grid.attach(app.intEntry, 1, 2, 1, 2, constFILL, 0, 0, 0)

let btnOk = buttonNew("OK")
btnOk.setSizeRequest(100, 40)
let hbox3 = hboxNew(false, 20)
hbox3.packEnd(btnOk, false, true, 10)
content.packStart(grid, true, true, 0)
content.packEnd(hbox3, false, false, 0)

app.window.setBorderWidth(5)
app.window.add content

discard btnOk.signalConnect("clicked", SIGNAL_FUNC(onOk), app.addr)

app.window.showAll()
main()
