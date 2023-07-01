import glib2, gtk2

proc printSize(window: PWindow): guint {.cdecl.} =
  var width, height: gint
  window.get_size(addr(width), addr(height))
  echo "W x H = ", width, " x ", height
  main_quit()

nim_init()

let window = window_new(WINDOW_TOPLEVEL)
window.maximize()
window.show_all()

discard g_timeout_add(100, printSize, addr(window[]))

main()
