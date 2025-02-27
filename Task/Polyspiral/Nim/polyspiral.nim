import std/[math, random]

import gtk2 except update
import gdk2, glib2, cairo

const
  Width = 500
  Height = 500
  DrawIters = 72
  Red = (1.0, 0.0, 0.0)
  Green = (0.0, 1.0, 0.0)
  Blue = (0.0, 0.0, 1.0)
  Black = (0.0, 0.0, 0.0)
  White = (1.0, 1.0, 1.0)
  Gold = (1.0, 215 / 255, 0.0)
  Colors = [Blue, Red, Green, White, Gold]
  Angles = [75, 100, 135, 160]

type

  Vec2 = tuple[x, y: float]
  Point = Vec2

  # Description of the simulation.
  Simulation = object
    area: PDrawingArea
    xmax, ymax: float
    center: Point
    itercount: int


proc initSimulation(area: PDrawingArea; width, height: int): Simulation {.noInit.} =
  ## Initialize a simulation object.
  result = Simulation(area: area,
                      xmax: float(width - 1),
                      ymax: float(height - 1),
                      center: (result.xmax * 0.5, result.ymax * 0.5))


func δ(r, θ: float): Vec2 =
  ## Return the delta in cartesian coordinates.
  (r * cos(degToRad(θ)), r * sin(degToRad(θ)))


func nextPoint(p: Point; r, θ: float): Point =
  ## Return the next point for given polar coordinates.
  let dp = δ(r, θ)
  result = (p.x + dp.x, p.y + dp.y)


template setColor(ctx: ptr Context; color: (float, float, float)) =
  ## Set the color for next drawing in given context.
  ctx.setSourceRgb(color[0], color[1], color[2])


proc draw(sim: var Simulation; context: ptr Context) =
  ## Draw the spiral.

  context.setColor(Black)
  context.rectangle(0, 0, sim.xmax, sim.ymax)
  context.fill()

  let colorIndex = sim.itercount mod Colors.len
  let color = Colors[colorIndex]

  var p1 = sim.center
  let δθ = Angles[sim.itercount mod Angles.len].toFloat
  var θ = δθ * rand(1.0) * 3
  var r = 5.0
  let δr = 3.0

  for _ in 1..DrawIters:
    let p2 = p1.nextPoint(r, θ)
    context.moveTo(p1.x, p1.y)
    context.setColor(color)
    context.lineTo(p2.x, p2.y)
    context.setLineWidth(2)
    context.stroke()
    θ += δθ
    r += δr
    p1 = p2


proc update(sim: var Simulation): gboolean =
  ## Update the simulation state.
  sim.draw(sim.area.window.cairoCreate())
  inc sim.itercount
  result = gboolean(1)


proc onDestroyEvent(widget: PWidget; data: pointer): gboolean {.cdecl.} =
  ## Quit the application.
  mainQuit()


nimInit()

let window = windowNew(WINDOW_TOPLEVEL)
window.setSizeRequest(Width, Height)
window.setTitle("Polyspiral")
discard window.signalConnect("destroy", SIGNAL_FUNC(onDestroyEvent), nil)

let area = drawingAreaNew()
window.add area

let sim = initSimulation(area, Width, Height)

discard timeoutAdd(500, cast[gtk2.TFunction](update), sim.addr)

window.showAll()
main()
