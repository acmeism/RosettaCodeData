import gdk2, glib2, gtk2

const
  Inside = "Mouse is over label"
  OutSide = "Mouse is not over label"

# Context transmitted to callback.
type Context = object
  label: PLabel
  overButton: bool


proc changeLabel(p: PWidget; event: gdk2.PEventCrossing; context: var Context) {.cdecl.} =
  context.label.set_text(if context.overButton: OutSide else: Inside)
  context.overButton = not context.overButton

proc thisDestroy(widget: PWidget, data: Pgpointer)  {.cdecl.} =
  main_quit()


var context: Context
nim_init()

let window = window_new(gtk2.WINDOW_TOPLEVEL)
let stackbox = vbox_new(true, 10)
let button1 = button_new("Move mouse over button")
let buttonstyle = copy(button1.get_style())
buttonstyle.bg[STATE_PRELIGHT] = TColor(pixel: 0, red: 255, green: 0, blue: 0)
button1.set_style(buttonstyle)
let button2 = button_new()
context = Context(label: label_new(Outside), overButton: false)
let button3 = button_new("Quit")

button2.add(context.label)
stackbox.pack_start(button1, true, true, 0)
stackbox.pack_start(button2, true, true, 0)
stackbox.pack_start(button3, true, true, 0)
window.set_border_width(5)
window.add(stackbox)

discard window.signal_connect("destroy", SIGNAL_FUNC(thisDestroy), nil)
discard button1.signal_connect("enter_notify_event", SIGNAL_FUNC(changeLabel), addr(context))
discard button1.signal_connect("leave_notify_event", SIGNAL_FUNC(changeLabel), addr(context))
discard button3.signal_connect("clicked", SIGNAL_FUNC(thisDestroy), nil)

window.show_all()
main()
