import std/strformat
import gtk2, glib2
import gdk2 except PWindow


proc onKeyPress(window: PWindow; event: PEventKey; label: PLabel): bool =
  let keyval = event.keyval.int
  if keyval in [ord('n'), ord('y')]:
    let text = &"You pressed key '{chr(keyval)}'"
    label.setText(text.cstring)
  result = true


proc onDestroyEvent(widget: PWidget; data: pointer): gboolean {.cdecl.} =
  ## Quit the application.
  mainQuit()


nimInit()
let window = windowNew(WINDOW_TOPLEVEL)
window.setSizeRequest(400, 200)
window.setTitle("Y/N response")

let hbox = hboxNew(false, 0)
window.add hbox
let vbox = vboxNew(false, 10)
hbox.packStart(vbox, true, true, 20)

let label1 = labelNew("   Press 'y' or 'n' key   ")
vbox.packStart(label1, true, true, 5)

let label2 = labelNew("")
vbox.packStart(label2, true, true, 5)

discard window.signalConnect("key-press-event", SIGNAL_FUNC(onKeyPress), label2)
discard window.signalConnect("destroy", SIGNAL_FUNC(onDestroyEvent), nil)

window.showAll()
main()
