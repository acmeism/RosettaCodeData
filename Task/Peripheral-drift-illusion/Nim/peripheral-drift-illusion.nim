import gintro/[glib, gobject, gtk, gio, cairo]

const
  Width = 600
  Height = 460

type
  Color = array[3, float]
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

  Black: Color = [0.0, 0.0, 0.0]
  Blue: Color = [0.2, 0.3, 1.0]
  White: Color = [1.0, 1.0, 1.0]
  Yellow: Color = [0.8, 0.8, 0.0]

  Colors: array[Edge, array[4, Color]] = [[White, Black, Black, White],
                                          [White, White, Black, Black],
                                          [Black, White, White, Black],
                                          [Black, Black, White, White]]

#---------------------------------------------------------------------------------------------------

proc draw(area: DrawingArea; context: Context) =
  ## Draw the pattern in the area.

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

#---------------------------------------------------------------------------------------------------

proc onDraw(area: DrawingArea; context: Context; data: pointer): bool =
  ## Callback to draw/redraw the drawing area contents.

  area.draw(context)
  result = true

#---------------------------------------------------------------------------------------------------

proc activate(app: Application) =
  ## Activate the application.

  let window = app.newApplicationWindow()
  window.setSizeRequest(Width, Height)
  window.setTitle("Peripheral drift illusion")

  # Create the drawing area.
  let area = newDrawingArea()
  window.add(area)

  # Connect the "draw" event to the callback to draw the pattern.
  discard area.connect("draw", ondraw, pointer(nil))

  window.showAll()

#———————————————————————————————————————————————————————————————————————————————————————————————————

let app = newApplication(Application, "Rosetta.Illusion")
discard app.connect("activate", activate)
discard app.run()
