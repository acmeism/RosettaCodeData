import gintro/[glib, gobject, gdk, gtk, gio]

type

  # Scrolling direction.
  ScrollDirection = enum toLeft, toRight

  # Data transmitted to update callback.
  UpdateData = ref object
    label: Label
    scrollDir: ScrollDirection

#---------------------------------------------------------------------------------------------------

proc update(data: UpdateData): gboolean =
  ## Update the text, scrolling to the right or to the left according to "data.scrollDir".

  data.label.setText(if data.scrollDir == toRight: data.label.text[^1] & data.label.text[0..^2]
                     else: data.label.text[1..^1] & data.label.text[0])
  result = gboolean(1)

#---------------------------------------------------------------------------------------------------

proc changeScrollingDir(evtBox: EventBox; event: EventButton; data: UpdateData): bool =
  ## Change scrolling direction.

  data.scrollDir = ScrollDirection(1 - ord(data.scrollDir))

#---------------------------------------------------------------------------------------------------

proc activate(app: Application) =
  ## Activate the application.

  let window = app.newApplicationWindow()
  window.setSizeRequest(150, 50)
  window.setTitle("Animation")

  # Create an event box to catch the button press event.
  let evtBox = newEventBox()
  window.add(evtBox)

  # Create the label and add it to the event box.
  let label = newLabel("Hello World! ")
  evtBox.add(label)

  # Create the update data.
  let data = UpdateData(label: label, scrollDir: toRight)

  # Connect the "button-press-event" to the callback to change scrolling direction.
  discard evtBox.connect("button-press-event", changeScrollingDir, data)

  # Create a timer to update the label and simulate scrolling.
  timeoutAdd(200, update, data)

  window.showAll()

#———————————————————————————————————————————————————————————————————————————————————————————————————

let app = newApplication(Application, "Rosetta.animation")
discard app.connect("activate", activate)
discard app.run()
