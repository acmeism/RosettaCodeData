import gtk2, glib2, gdk2, cairo

const
  Width = 600
  Height = 460

type
  Color = (float, float, float)
  Edge {.pure.} = enum LT, TR, RB, BL

const

  Edges = [[LT, BL, BL, RB, RB, TR, TR, LT, LT, BL, BL, RB],
           [LT, LT, BL, BL, RB, RB, TR, TR, LT, LT, BL, BL],
           [TR, LT, LT, BL, BL, RB, RB, TR, TR, LT, LT, BL],
           [TR, TR, LT, LT, BL, BL, RB, RB, TR, TR, LT, LT],
           [RB, TR, TR, LT, LT, BL, BL, RB, RB, TR, TR, LT],
           [RB, RB, TR, TR, LT, LT, BL, BL, RB, RB, TR, TR],
           [BL, RB, RB, TR, TR, LT, LT, BL, BL, RB, RB, TR],
           [BL, BL, RB, RB, TR, TR, LT, LT, BL, BL, RB, RB],
           [LT, BL, BL, RB, RB, TR, TR, LT, LT, BL, BL, RB],
           [LT, LT, BL, BL, RB, RB, TR, TR, LT, LT, BL, BL],
           [TR, LT, LT, BL, BL, RB, RB, TR, TR, LT, LT, BL],
           [TR, TR, LT, LT, BL, BL, RB, RB, TR, TR, LT, LT]]

  Black: Color = (0.0, 0.0, 0.0)
  Blue: Color = (0.2, 0.3, 1.0)
  White: Color = (1.0, 1.0, 1.0)
  Yellow: Color = (0.8, 0.8, 0.0)

  Colors: array[Edge, array[4, Color]] = [[White, Black, Black, White],
                                          [White, White, Black, Black],
                                          [Black, White, White, Black],
                                          [Black, Black, White, White]]


template setSource(ctx: ptr Context; color: Color) =
  ctx.setSourceRgb(color[0], color[1], color[2])


proc draw(context: ptr Context) =
  ## Draw the pattern.

  func line(x1, y1, x2, y2: float; color: Color) =
    context.setSource(color)
    context.moveTo(x1, y1)
    context.lineTo(x2, y2)
    context.stroke

  context.setSource(Yellow)
  context.rectangle(0, 0, Width, Height)
  context.fill()

  for x in 0..11:
    let px = float(86 + x * 36)
    for y in 0..11:
      let py = float(16 + y * 36)
      context.setSource(Blue)
      context.rectangle(px, py, 24, 24)
      context.fill()
      let carray = Colors[Edges[y][x]]
      context.setLineWidth(2)
      line(px, py, px + 23, py, carray[0])
      line(px + 23, py, px + 23, py + 23, carray[1])
      line(px + 23, py + 23, px, py + 23, carray[2])
      line(px, py + 23, px, py, carray[3])


proc onExposeEvent(area: PDrawingArea; event: PEventExpose; data: pointer): gboolean {.cdecl.} =
  ## Callback to draw/redraw the drawing area contents.
  let context = cairoCreate(area.window)
  context.draw()
  result = true


proc onDestroyEvent(widget: PWidget; data: pointer): gboolean {.cdecl.} =
  ## Process the "destroy" event.
  mainQuit()


nimInit()
let window = windowNew(WINDOW_TOPLEVEL)
window.setSizeRequest(Width, Height)
window.setTitle("Peripheral drift illusion")

# Create the drawing area.
let area = drawingAreaNew()
window.add area

# Connect the "expose" event to the callback to draw the pattern.
discard area.signalConnect("expose-event", SIGNAL_FUNC(onExposeEvent), nil)

# Quit the application if the window is closed.
discard window.signalConnect("destroy", SIGNAL_FUNC(onDestroyEvent), nil)

window.showAll()
main()
