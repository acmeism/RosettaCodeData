import gtk2 except update
import glib2, gdk2, cairo


const Palette = [(166.0, 124.0,   0.0),
                 (191.0, 155.0,  48.0),
                 (255.0, 191.0,   0.0),
                 (255.0, 207.0,  64.0),
                 (255.0, 220.0, 115.0)]

type
  # Description of the simulation.
  Simulation = object
    area: PDrawingArea
    horizontal: bool
    paletteIndex: Natural
    count: int

  Color = (float, float, float)


proc bar(cr: ptr Context; x1, y1, x2, y2: int; c: Color) =
  ## Draw a bar.
  cr.setSourceRgb(c[0], c[1], c[2])
  cr.rectangle(x1.toFloat, y1.toFloat, (x2 - x1 + 1).toFloat, (y2 - y1 + 1).toFloat)
  cr.fill()


proc draw(sim: var Simulation; cr: ptr Context) =
  ## Draw the bars.
  var width, height: gint
  sim.area.window.getSize(width.addr, height.addr)

  if sim.horizontal:
    for i in countup(0, height - 4, 20):
      cr.bar(0, i, width - 1, i + 19, Palette[sim.paletteIndex])
      sim.paletteIndex = (sim.paletteIndex + 1) mod 5
  else:
    for i in countup(0, width - 4, 20):
      cr.bar(i, 0, i + 19, height - 1, Palette[sim.paletteIndex])
      sim.paletteIndex = (sim.paletteIndex + 1) mod 5


proc update(sim: var Simulation): gboolean =
  ## Update the simulation state.
  sim.draw(sim.area.window.cairoCreate())
  sim.area.showAll()
  sim.paletteIndex = (sim.paletteIndex + 2) mod 5
  inc sim.count
  if sim.count mod 30 == 29:
    sim.horizontal = not sim.horizontal
  result = true


proc onDestroyEvent(widget: PWidget; data: pointer): gboolean {.cdecl.} =
  ## Quit the application.
  mainQuit()


nimInit()

let window = windowNew(WINDOW_TOPLEVEL)
window.setSizeRequest(500, 500)
window.setTitle("Raster Bar Demo")
discard window.signalConnect("destroy", SIGNAL_FUNC(onDestroyEvent), nil)

let area = drawingAreaNew()
window.add area

var sim = Simulation(area: area, horizontal: true, paletteIndex: 0, count: 0)
discard timeoutAdd(50, cast[gtk2.TFunction](update), sim.addr)

window.showAll()
main()
