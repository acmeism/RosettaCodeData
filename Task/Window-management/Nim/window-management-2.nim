import os
import gdk2, glib2, gtk2

proc thisDestroy(widget: PWidget; data: Pgpointer) {.cdecl.} =
  main_quit()

proc thisMax(widget: PWidget; data: Pgpointer) {.cdecl.} =
  widget.get_parent_window().maximize()

proc thisUnmax(widget: PWidget; data: Pgpointer) {.cdecl.} =
  widget.get_parent_window().unmaximize()

proc thisIcon(widget: PWidget; data: Pgpointer) {.cdecl.} =
  widget.get_parent_window().iconify()

proc thisDeicon(widget: PWidget; data: Pgpointer) {.cdecl.} =
  widget.get_parent_window().deiconify()

proc thisHide(widget: PWidget; data: Pgpointer) {.cdecl.} =
  widget.get_parent_window().hide()
  window_process_all_updates()
  sleep(2000)
  widget.get_parent_window().show()

proc thisShow(widget: PWidget; data: Pgpointer) {.cdecl.} =
  widget.get_parent_window().show()

var isShifted = false

proc thisMove(widget: PWidget; data: Pgpointer) {.cdecl.} =
  var x, y: gint
  widget.get_parent_window().get_position(addr(x), addr(y))
  if isshifted:
     widget.get_parent_window().move(x - 10, y - 10)
  else:
     widget.get_parent_window().move(x + 10, y + 10)
  isShifted = not isShifted


nim_init()
let window = window_new(gtk2.WINDOW_TOPLEVEL)
discard window.allow_grow()
window.set_title("Window management")
let
  stackbox = vbox_new(true, 10)
  bMax = button_new("maximize")
  bUnmax = button_new("unmaximize")
  bIcon = button_new("iconize")
  bDeicon = button_new("deiconize")
  bHide = button_new("hide")
  bShow = button_new("show")
  bMove = button_new("move")
  bQuit = button_new("Quit")

stackbox.pack_start(bMax, true, true, 0)
stackbox.pack_start(bUnmax, true, true, 0)
stackbox.pack_start(bIcon, true, true, 0)
stackbox.pack_start(bDeicon, true, true, 0)
stackbox.pack_start(bHide, true, true, 0)
stackbox.pack_start(bShow, true, true, 0)
stackbox.pack_start(bMove, true, true, 0)
stackbox.pack_start(bQuit, true, true, 0)
window.set_border_width(5)
window.add(stackbox)

discard window.signal_connect("destroy", SIGNAL_FUNC(thisDestroy), nil)
discard bIcon.signal_connect("clicked", SIGNAL_FUNC(thisIcon), nil)
discard bDeicon.signal_connect("clicked", SIGNAL_FUNC(thisDeicon), nil)
discard bMax.signal_connect("clicked", SIGNAL_FUNC(thisMax), nil)
discard bUnmax.signal_connect("clicked", SIGNAL_FUNC(thisUnmax), nil)
discard bHide.signal_connect("clicked", SIGNAL_FUNC(thisHide), nil)
discard bShow.signal_connect("clicked", SIGNAL_FUNC(thisShow), nil)
discard bMove.signal_connect("clicked", SIGNAL_FUNC(thismove), nil)
discard bQuit.signal_connect("clicked", SIGNAL_FUNC(thisDestroy), nil)
window.show_all()
main()
