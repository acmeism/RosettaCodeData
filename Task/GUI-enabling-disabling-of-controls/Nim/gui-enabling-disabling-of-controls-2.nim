import strutils
import gintro/[glib, gobject, gtk, gio]

type Context = ref object
  value: int
  entry: Entry
  btnIncr: Button
  btnDecr: Button

#---------------------------------------------------------------------------------------------------

proc checkButtons(ctx: Context) =
  ctx.btnIncr.setSensitive(ctx.value < 10)
  ctx.btnDecr.setSensitive(ctx.value > 0)
  ctx.entry.setSensitive(ctx.value == 0)

#---------------------------------------------------------------------------------------------------

proc onQuit(button: Button; window: ApplicationWindow) =
  window.destroy()

#---------------------------------------------------------------------------------------------------

proc onIncr(button: Button; ctx: Context) =
  inc ctx.value
  ctx.entry.setText($ctx.value)
  ctx.checkButtons()

#---------------------------------------------------------------------------------------------------

proc onDecr(button: Button; ctx: Context) =
  dec ctx.value
  ctx.entry.setText($ctx.value)
  ctx.checkButtons()

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
  window.setTitle("GUI controls")

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
  let btnDecr = newButton("Decrement")

  hbox2.add(label)
  hbox2.add(entry)
  hbox1.add(btnIncr)
  hbox1.add(btnDecr)

  content.packStart(hbox2, true, true, 0)
  content.packStart(hbox1, true, true, 0)
  content.packStart(btnQuit, true, true, 0)

  window.setBorderWidth(5)
  window.add(content)

  let context = Context(value: 0, entry: entry, btnIncr: btnIncr, btnDecr: btnDecr)

  discard btnQuit.connect("clicked", onQuit, window)
  discard btnIncr.connect("clicked", onIncr, context)
  discard btnDecr.connect("clicked", onDecr, context)
  discard entry.connect("changed", onEntryChange, context)

  context.checkButtons()
  window.showAll()

#———————————————————————————————————————————————————————————————————————————————————————————————————

let app = newApplication(Application, "Rosetta.GuiControls")
discard app.connect("activate", activate)
discard app.run()
