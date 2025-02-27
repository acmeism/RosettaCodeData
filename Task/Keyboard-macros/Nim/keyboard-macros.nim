import tables

import gtk2, glib2
import gdk2 except PWindow

type

  MacroProc = proc(app: var App)
  MacroTable = Table[int, MacroProc]  # Mapping key values -> procedures.

  App = object
    dispatchTable: MacroTable
    label: PLabel


proc addMacro(app: var App; ch: char; macroProc: MacroProc) =
  ## Assign a procedure to a key.
  ## If the key is already assigned, nothing is done.
  let keyval = ord(ch)
  if keyval notin app.dispatchTable:
    app.dispatchTable[keyval] = macroProc


# Macro procedures.

proc proc1(app: var App) =
  app.label.setText("You called macro 1")

proc proc2(app: var App) =
  app.label.setText("You called macro 2")

proc proc3(app: var App) =
  app.label.setText("You called macro 3")


proc onKeyPress(window: PWindow; event: PEventKey; app: var App): bool =
  let keyval = event.keyval.int
  if keyval in app.dispatchTable:
    app.dispatchTable[keyval](app)
  result = true


proc onDestroyEvent(widget: PWidget; data: pointer): gboolean {.cdecl.} =
  ## Quit the application.
  mainQuit()


var app: App

nimInit()

app.addMacro('1', proc1)
app.addMacro('2', proc2)
app.addMacro('3', proc3)

let window = windowNew(WINDOW_TOPLEVEL)
window.setTitle("Keyboard macros")
window.setSizeRequest(300, 50)
discard window.signalConnect("destroy", SIGNAL_FUNC(onDestroyEvent), nil)

let hbox = hboxNew(false, 10)
window.add hbox
let vbox = vboxNew(false, 10)
hbox.packStart(vbox, true, true, 10)

app.label = labelNew(nil)
app.label.setWidthChars(18)
vbox.packStart(app.label, true, true, 5)

discard window.signalConnect("key-press-event", SIGNAL_FUNC(onKeyPress), app.addr)

window.showAll()
main()
