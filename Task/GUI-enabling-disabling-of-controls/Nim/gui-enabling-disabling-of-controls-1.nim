import gtk2, strutils, glib2

var valu: int = 0

proc thisDestroy(widget: PWidget, data: Pgpointer){.cdecl.} =
  main_quit()

nim_init()
var window = window_new(gtk2.WINDOW_TOPLEVEL)
var content = vbox_new(true,10)
var hbox1 = hbox_new(true,10)
var entry_fld = entry_new()
entry_fld.set_text("0")
var btn_quit = button_new("Quit")
var btn_inc = button_new("Increment")
var btn_dec = button_new("Decrement")
add(hbox1,btn_inc)
add(hbox1,btn_dec)
pack_start(content, entry_fld, true, true, 0)
pack_start(content, hbox1, true, true, 0)
pack_start(content, btn_quit, true, true, 0)
set_border_width(window, 5)
add(window, content)

proc thisCheckBtns =
   set_sensitive(btn_inc, valu < 10)
   set_sensitive(btn_dec, valu > 0)
   set_sensitive(entry_fld, valu == 0)

proc thisInc(widget: PWidget, data: Pgpointer){.cdecl.} =
  inc(valu)
  entry_fld.set_text($valu)
  thisCheckBtns()

proc thisDec(widget: PWidget, data: Pgpointer){.cdecl.} =
  dec(valu)
  entry_fld.set_text($valu)
  thisCheckBtns()

proc thisTextChanged(widget: PWidget, data: Pgpointer) {.cdecl.} =
  try:
     valu = parseInt($entry_fld.get_text())
  except ValueError:
     entry_fld.set_text($valu)
  thisCheckBtns()

discard signal_connect(window, "destroy",
                   SIGNAL_FUNC(thisDestroy), nil)
discard signal_connect(btn_quit, "clicked",
                   SIGNAL_FUNC(thisDestroy), nil)
discard signal_connect(btn_inc, "clicked",
                   SIGNAL_FUNC(thisInc), nil)
discard signal_connect(btn_dec, "clicked",
                   SIGNAL_FUNC(thisDec), nil)
discard signal_connect(entry_fld, "changed",
                   SIGNAL_FUNC(thisTextChanged), nil)

show_all(window)
thisCheckBtns()
main()
