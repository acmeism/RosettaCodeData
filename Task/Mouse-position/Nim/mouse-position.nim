import gintro/[glib, gobject, gtk, gio]
import gintro/gdk except Window

#---------------------------------------------------------------------------------------------------

proc onButtonPress(window: ApplicationWindow; event: Event; data: pointer): bool =
  echo event.getCoords()
  result = true

#---------------------------------------------------------------------------------------------------

proc activate(app: Application) =
  ## Activate the application.

  let window = app.newApplicationWindow()
  window.setTitle("Mouse position")
  window.setSizeRequest(640, 480)

  discard window.connect("button-press-event", onButtonPress, pointer(nil))

  window.showAll()

#———————————————————————————————————————————————————————————————————————————————————————————————————

let app = newApplication(Application, "Rosetta.MousePosition")
discard app.connect("activate", activate)
discard app.run()
