import std/sugar

import gtk2 except update
import gdk2, glib2, cairo

type Color = (float, float, float)

const
  Width = 640
  Height = 480
  X0 = Width div 2 - 1
  Y0 = Height div 2 - 1
  Colors = [Color (0.0, 0.0, 0.0), (1.0, 0.0, 0.0), (0.0, 1.0, 0.0), (0.0, 0.0, 1.0),
                  (1.0, 0.0, 1.0), (0.0, 1.0, 1.0), (1.0, 1.0, 0.0), (1.0, 1.0, 1.0)]
  Sizes = collect(newSeq, for size in countdown(Width, 4, 16): float(size))

type
  # Description of the simulation.
  Simulation = object
    area: PDrawingArea      # Drawing area.
    isize: Natural          # Size index.
    icolor: Natural         # Color index.


template setColor(cr: ptr Context; color: Color) =
  ## Set color for drawing.
  cr.setSourceRgb(color[0], color[1], color[2])


proc draw(sim: Simulation; cr: ptr Context) =
  ## Draw the rectangles.
  cr.setColor(Colors[sim.icolor])
  let width = Sizes[sim.isize]
  let height = width * 3 / 4
  cr.rectangle(X0 - width * 0.5, Y0 - height * 0.5, width, height)
  cr.stroke()


proc update(sim: var Simulation): gboolean =
  ## Update the simulation state.
  sim.isize = (sim.isize + 1) mod Sizes.len
  if sim.isize == 0:
    # Change color for next cycle.
    sim.icolor = (sim.icolor + 1) mod Colors.len
  sim.draw(sim.area.window.cairoCreate())
  result = true

proc onDestroyEvent(widget: PWidget; data: pointer): gboolean {.cdecl.} =
  ## Quit the application.
  mainQuit()

nimInit()
let window = windowNew(WINDOW_TOPLEVEL)
window.setSizeRequest(Width, Height)
window.setTitle("Vibrating rectangles")
discard window.signalConnect("destroy", SIGNAL_FUNC(onDestroyEvent), nil)

let area = drawingAreaNew()
window.add area

var sim = Simulation(area: area, isize: 0)
discard timeoutAdd(40, cast[gtk2.TFunction](update), sim.addr)
window.showAll()
main()
