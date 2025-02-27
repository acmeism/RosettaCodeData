import gtk2, glib2, gdk2, cairo

const
  Width = 420
  Height = 420

const Colors = [(1.0, 1.0, 1.0), (0.0, 0.0, 0.0)]


proc onExposeEvent(widget: PWidget; event: PEventExpose; data: Pgpointer): gboolean {.cdecl.} =
  ## Draw the bars.

  const lineHeight = Height div 4

  let cr = cairo_create(widget.window)

  var y = 0.0
  for lineWidth in [1.0, 2.0, 3.0, 4.0]:
    cr.setLineWidth(lineWidth)
    var x = 0.0
    var colorIndex = 0
    while x < Width:
      let (r, g, b) = Colors[colorIndex]
      cr.setSourceRgb(r, g, b)
      cr.moveTo(x, y)
      cr.lineTo(x, y + lineHeight)
      cr.stroke()
      colorIndex = 1 - colorIndex
      x += lineWidth
    y += lineHeight

  cr.destroy()


proc onDestroyEvent(widget: PWidget; data: Pgpointer): gboolean {.cdecl.} =
  ## Quit the application.
  main_quit()


nim_init()
let window = window_new(gtk2.WINDOW_TOPLEVEL)
window.set_title("Pinstripe")

let drawingArea = drawing_area_new()
window.add drawingArea
drawingArea.set_size_request(Width, Height)

discard drawingArea.signal_connect("expose-event", SIGNAL_FUNC(onExposeEvent), nil)
discard window.signal_connect("destroy", SIGNAL_FUNC(onDestroyEvent), nil)

window.show_all()
main()
