import tables

import gintro/[glib, gobject, gio]
import gintro/gtk except Table
import gintro/gdk except Window

type

  MacroProc = proc(app: App)
  MacroTable = Table[int, MacroProc]  # Mapping key values -> procedures.

  App = ref object of Application
    dispatchTable: MacroTable
    label: Label

#---------------------------------------------------------------------------------------------------

proc addMacro(app: App; ch: char; macroProc: MacroProc) =
  ## Assign a procedure to a key.
  ## If the key is already assigned, nothing is done.
  let keyval = ord(ch)
  if keyval notin app.dispatchTable:
    app.dispatchTable[keyval] = macroProc

#---------------------------------------------------------------------------------------------------
# Macro procedures.

proc proc1(app: App) =
  app.label.setText("You called macro 1")

proc proc2(app: App) =
  app.label.setText("You called macro 2")

proc proc3(app: App) =
  app.label.setText("You called macro 3")

#---------------------------------------------------------------------------------------------------

proc onKeyPress(window: ApplicationWindow; event: Event; app: App): bool =
  var keyval: int
  if not event.getKeyval(keyval): return false
  if keyval in app.dispatchTable:
    app.dispatchTable[keyval](app)
  result = true

#---------------------------------------------------------------------------------------------------

proc activate(app: App) =
  ## Activate the application.

  app.addMacro('1', proc1)
  app.addMacro('2', proc2)
  app.addMacro('3', proc3)

  let window = app.newApplicationWindow()
  window.setTitle("Keyboard macros")

  let hbox = newBox(Orientation.horizontal, 10)
  window.add(hbox)
  let vbox = newBox(Orientation.vertical, 10)
  hbox.packStart(vbox, true, true, 10)

  app.label = newLabel()
  app.label.setWidthChars(18)
  vbox.packStart(app.label, true, true, 5)

  discard window.connect("key-press-event", onKeyPress, app)

  window.showAll()

#———————————————————————————————————————————————————————————————————————————————————————————————————

let app = newApplication(App, "Rosetta.KeyboardMacros")
discard app.connect("activate", activate)
discard app.run()
