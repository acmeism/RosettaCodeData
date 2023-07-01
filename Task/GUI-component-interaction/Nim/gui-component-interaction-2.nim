import random, strutils
import gintro/[glib, gobject, gtk, gio]

type Context = ref object
  value: int
  entry: Entry

#---------------------------------------------------------------------------------------------------

proc onQuestionClicked(): bool =

  # As "gintro" doesn't provide "MessageDialog" yet, we will use a simple dialog.
  let dialog = newDialog()
  dialog.setModal(true)
  let label = newLabel("Use a Random number?")
  dialog.contentArea.add(label)
  discard dialog.addButton("No", ord(ResponseType.no))
  discard dialog.addButton("Yes", ord(ResponseType.yes))
  dialog.showAll()
  result = dialog.run() == ord(ResponseType.yes)
  dialog.destroy()

#---------------------------------------------------------------------------------------------------

proc onQuit(button: Button; window: ApplicationWindow) =
  window.destroy()

#---------------------------------------------------------------------------------------------------

proc onIncr(button: Button; ctx: Context) =
  inc ctx.value
  ctx.entry.setText($ctx.value)

#---------------------------------------------------------------------------------------------------

proc onRand(button: Button; ctx: Context) =
  if onQuestionClicked():
    ctx.value = rand(20)
    ctx.entry.setText($ctx.value)

#---------------------------------------------------------------------------------------------------

proc onEntryChange(entry: Entry; ctx: Context) =
  try:
    ctx.value = entry.text().parseInt()
  except ValueError:
    entry.setText($ctx.value)

#---------------------------------------------------------------------------------------------------

proc activate(app: Application) =
  ## Activate the application.

  let window = app.newApplicationWindow()
  window.setTitle("Component interaction")

  let content = newBox(Orientation.vertical, 10)
  content.setHomogeneous(true)
  let hbox1 = newBox(Orientation.horizontal, 10)
  hbox1.setHomogeneous(true)
  let hbox2 = newBox(Orientation.horizontal, 1)
  hbox2.setHomogeneous(false)
  let label = newLabel("Value:")
  let entry = newEntry()
  entry.setText("0")
  let btnQuit = newButton("Quit")
  let btnIncr = newButton("Increment")
  let btnRand = newButton("Random")

  hbox2.add(label)
  hbox2.add(entry)
  hbox1.add(btnIncr)
  hbox1.add(btnRand)

  content.packStart(hbox2, true, true, 0)
  content.packStart(hbox1, true, true, 0)
  content.packStart(btnQuit, true, true, 0)

  window.setBorderWidth(5)
  window.add(content)

  let context = Context(value: 0, entry: entry)

  discard btnQuit.connect("clicked", onQuit, window)
  discard btnIncr.connect("clicked", onIncr, context)
  discard btnRand.connect("clicked", onRand, context)
  discard entry.connect("changed", onEntryChange, context)

  window.showAll()

#———————————————————————————————————————————————————————————————————————————————————————————————————

let app = newApplication(Application, "Rosetta.ComponentInteraction")
discard app.connect("activate", activate)
discard app.run()
