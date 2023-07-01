import gintro/[glib, gobject, gtk, gio]

proc activate(app: Application) =
  ## Activate the application.
  let window = newApplicationWindow(app)
  window.setTitle("Window for Rosetta")
  window.setSizeRequest(640, 480)
  window.showAll()

let app = newApplication(Application, "Rosetta.Window")
discard app.connect("activate", activate)
discard app.run()
