import strutils
import gintro/[glib, gobject, gtk, gio]

type MainWindow = ref object of ApplicationWindow
  strEntry: Entry
  intEntry: SpinButton

#---------------------------------------------------------------------------------------------------

proc displayValues(strval: string; intval: int) =
  ## Display a dialog window with the values entered by the user.

  let dialog = newDialog()
  dialog.setModal(true)
  let label1 = newLabel(" String value is “$1”.".format(strval))
  label1.setHalign(Align.start)
  dialog.contentArea.packStart(label1, true, true, 5)
  let msg = " Integer value is $1 which is ".format(intval) &
            (if intval == 75000: "right. " else: "wrong (expected 75000). ")
  let label2 = newLabel(msg)
  dialog.contentArea.packStart(label2, true, true, 5)
  discard dialog.addButton("OK", ord(ResponseType.ok))
  dialog.showAll()
  discard dialog.run()
  dialog.destroy()

#---------------------------------------------------------------------------------------------------

proc onOk(button: Button; window: MainWindow) =
  ## Callback executed when the OK button has been clicked.
  let strval = window.strEntry.text()
  let intval = window.intEntry.value().toInt
  displayValues(strval, intval)
  if intval == 75_000:
    window.destroy()

#---------------------------------------------------------------------------------------------------

proc activate(app: Application) =
  ## Activate the application.

  let window = newApplicationWindow(MainWindow, app)
  window.setTitle("User input")

  let content = newBox(Orientation.vertical, 10)
  content.setHomogeneous(true)
  let grid = newGrid()
  grid.setColumnSpacing(30)
  let bbox = newButtonBox(Orientation.horizontal)
  bbox.setLayout(ButtonBoxStyle.spread)

  let strLabel = newLabel("Enter some text")
  strLabel.setHalign(Align.start)
  window.strEntry = newEntry()
  grid.attach(strLabel, 0, 0, 1, 1)
  grid.attach(window.strEntry, 1, 0, 1, 1)

  let intLabel = newLabel("Enter 75000")
  intLabel.setHalign(Align.start)
  window.intEntry = newSpinButtonWithRange(0, 80_000, 1)
  grid.attach(intLabel, 0, 1, 1, 1)
  grid.attach(window.intEntry, 1, 1, 1, 1)

  let btnOk = newButton("OK")

  bbox.add(btnOk)

  content.packStart(grid, true, true, 0)
  content.packEnd(bbox, true, true, 0)

  window.setBorderWidth(5)
  window.add(content)

  discard btnOk.connect("clicked", onOk, window)

  window.showAll()

#———————————————————————————————————————————————————————————————————————————————————————————————————

let app = newApplication(Application, "Rosetta.UserInput")
discard app.connect("activate", activate)
discard app.run()
