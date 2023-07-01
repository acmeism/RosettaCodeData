import strformat
import gintro/[glib, gobject, gtk, gio]
import gintro/gdk except Window

#---------------------------------------------------------------------------------------------------

proc onKeyPress(window: ApplicationWindow; event: Event; label: Label): bool =
  var keyval: int
  if not event.getKeyval(keyval): return false
  if keyval in [ord('n'), ord('y')]:
    label.setText(&"You pressed key '{chr(keyval)}'")
  result = true

#---------------------------------------------------------------------------------------------------

proc activate(app: Application) =
  ## Activate the application.

  let window = app.newApplicationWindow()
  window.setTitle("Y/N response")

  let hbox = newBox(Orientation.horizontal, 0)
  window.add(hbox)
  let vbox = newBox(Orientation.vertical, 10)
  hbox.packStart(vbox, true, true, 20)

  let label1 = newLabel("   Press 'y' or 'n' key   ")
  vbox.packStart(label1, true, true, 5)

  let label2 = newLabel()
  vbox.packStart(label2, true, true, 5)

  discard window.connect("key-press-event", onKeyPress, label2)

  window.showAll()

#———————————————————————————————————————————————————————————————————————————————————————————————————

let app = newApplication(Application, "Rosetta.YNResponse")
discard app.connect("activate", activate)
discard app.run()
