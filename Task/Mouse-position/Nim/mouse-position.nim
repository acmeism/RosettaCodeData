import gtk2, glib2
import gdk2 except PWindow


proc onButtonPress(window: pointer; event: PEventButton; data: pointer): gboolean {.cdecl.} =
  echo event.x, " ", event.y
  result = false


proc onDestroyEvent(widget: PWidget; data: pointer): gboolean {.cdecl.} =
  ## Quit the application.
  mainQuit()


nimInit()

let window = windowNew(WINDOW_TOPLEVEL)
window.setTitle("Mouse position")
window.setSizeRequest(640, 480)
window.setEvents(BUTTON_PRESS_MASK)
discard window.signalConnect("destroy", SIGNAL_FUNC(onDestroyEvent), nil)
discard window.signalConnect("button-press-event", SIGNAL_FUNC(onButtonPress), nil)
window.showAll()

main()
