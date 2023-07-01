import
  gtk2, glib2, strutils, random

var valu: int = 0

proc thisDestroy(widget: PWidget, data: Pgpointer) {.cdecl.} =
  main_quit()

randomize()
nim_init()
var win = window_new(gtk2.WINDOW_TOPLEVEL)
var content = vbox_new(true,10)
var hbox1 = hbox_new(true,10)
var hbox2 = hbox_new(false,1)
var lbl = label_new("Value:")
var entry_fld = entry_new()
entry_fld.set_text("0")
var btn_quit = button_new("Quit")
var btn_inc = button_new("Increment")
var btn_rnd = button_new("Random")
add(hbox2,lbl)
add(hbox2,entry_fld)
add(hbox1,btn_inc)
add(hbox1,btn_rnd)
pack_start(content, hbox2, true, true, 0)
pack_start(content, hbox1, true, true, 0)
pack_start(content, btn_quit, true, true, 0)
set_border_width(win, 5)
add(win, content)

proc on_question_clicked: bool =
  var dialog = win.message_dialog_new(0, MESSAGE_QUESTION,
    BUTTONS_YES_NO, "Use a Random number?")
  var response = dialog.run()
  result = response == RESPONSE_YES
  dialog.destroy()

proc thisInc(widget: PWidget, data: Pgpointer){.cdecl.} =
  inc(valu)
  entry_fld.set_text($valu)

proc thisRnd(widget: PWidget, data: Pgpointer){.cdecl.} =
  if on_question_clicked():
    valu = rand(20)
    entry_fld.set_text($valu)

proc thisTextChanged(widget: PWidget, data: Pgpointer) {.cdecl.} =
  try:
    valu = parseInt($entry_fld.get_text())
  except ValueError:
    entry_fld.set_text($valu)

discard signal_connect(win, "destroy", SIGNAL_FUNC(thisDestroy), nil)
discard signal_connect(btn_quit, "clicked", SIGNAL_FUNC(thisDestroy), nil)
discard signal_connect(btn_inc, "clicked", SIGNAL_FUNC(thisInc), nil)
discard signal_connect(btn_rnd, "clicked", SIGNAL_FUNC(thisRnd), nil)
discard signal_connect(entry_fld, "changed", SIGNAL_FUNC(thisTextChanged), nil)

win.show_all()
main()
