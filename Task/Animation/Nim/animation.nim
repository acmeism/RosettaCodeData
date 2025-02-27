import gtk2, gdk2, glib2

type

  # Scrolling direction.
  ScrollDirection = enum toLeft, toRight

  # Data transmitted to update callback.
  UpdateData = object
    label: PLabel
    scrollDir: ScrollDirection


proc update(data: var UpdateData): gboolean {.cdecl.} =
  ## Update the text, scrolling to the right or to the left according to "data.scrollDir".
  let text = $data.label.text   # Get text as a Nim string.
  let newText = if data.scrollDir == toRight: text[^1] & text[0..^2]
                else: text[1..^1] & text[0]
  data.label.setText(newText.cstring)
  result = gboolean(1)


proc changeScrollingDir(evtBox: PEventBox; event: PEventButton; data: ptr UpdateData): bool =
  ## Change scrolling direction.
  data.scrollDir = ScrollDirection(1 - ord(data.scrollDir))


proc onDestroyEvent(widget: PWidget; data: Pgpointer): gboolean {.cdecl.} =
  ## Process the "destroy" event.
  main_quit()



nim_init()

let window = window_new(WINDOW_TOPLEVEL)
window.set_size_request(150, 50)
window.set_title("Animation")

# Create an event box to catch the button press event.
let evtBox = event_box_new()
window.add evtBox

# Create the label and add it to the event box.
let label = label_new("Hello World! ")
evtBox.add label

# Create the update data.
var data = UpdateData(label: label, scrollDir: toRight)

# Connect the "button-press-event" to the callback to change the scrolling direction.
discard evtBox.signal_connect("button-press-event", SIGNAL_FUNC(changeScrollingDir), data.addr)

# Quit the application if the window is closed.
discard window.signal_connect("destroy", SIGNAL_FUNC(onDestroyEvent), nil)

# Create a timer to update the label and simulate scrolling.
discard timeout_add(200, cast[gtk2.TFunction](animation.update), data.addr)

window.showAll()
main()
