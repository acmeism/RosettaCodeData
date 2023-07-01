import gintro/[glib, gobject, gtk, gio]

var window: ApplicationWindow

#---------------------------------------------------------------------------------------------------

proc printSize(data: pointer): gboolean {.cdecl.} =
  var width, height: int
  window.getSize(width, height)
  echo "W x H = ", width, " x ", height
  window.destroy()

#---------------------------------------------------------------------------------------------------

proc activate(app: Application) =
  ## Activate the application.

  window = app.newApplicationWindow()
  window.maximize()
  window.showAll()

  discard timeoutAdd(PRIORITY_DEFAULT, 100, SourceFunc(printSize), nil, nil)

#———————————————————————————————————————————————————————————————————————————————————————————————————

let app = newApplication(Application, "Rosetta.ScreenSize")
discard app.connect("activate", activate)
discard app.run()
