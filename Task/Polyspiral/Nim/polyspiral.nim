# Pendulum simulation.

import math, random

import gintro/[gobject, gdk, gtk, gio, glib, cairo]

const
  Width = 500
  Height = 500
  DrawIters = 72
  Red = [float 1, 0, 0]
  Green = [float 0, 1, 0]
  Blue = [float 0, 0, 1]
  Black = [float 0, 0, 0]
  White = [float 255, 255, 255]
  Gold = [float 255, 215, 0]
  Colors = [Blue, Red, Green, White, Gold]
  Angles = [75, 100, 135, 160]

type

  Vec2 = tuple[x, y: float]
  Point = Vec2

  # Description of the simulation.
  Simulation = ref object
    area: DrawingArea
    xmax, ymax: float
    center: Point
    itercount: int

#---------------------------------------------------------------------------------------------------

proc newSimulation(area: DrawingArea; width, height: int): Simulation {.noInit.} =
  ## Allocate and initialize the simulation object.

  new(result)
  result.area = area
  result.xmax = float(width - 1)
  result.ymax = float(height - 1)
  result.center = (result.xmax * 0.5, result.ymax * 0.5)

#---------------------------------------------------------------------------------------------------

func δ(r, θ: float): Vec2 = (r * cos(degToRad(θ)), r * sin(degToRad(θ)))

#---------------------------------------------------------------------------------------------------

func nextPoint(p: Point; r, θ: float): Point =
  let dp = δ(r, θ)
  result = (p.x + dp.x, p.y + dp.y)

#---------------------------------------------------------------------------------------------------

proc draw(sim: Simulation; context: cairo.Context) =
  ## Draw the spiral.

  context.setSource(Black)
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
    context.setSource(color)
    context.lineTo(p2.x, p2.y)
    context.setLineWidth(2)
    context.stroke()
    θ += δθ
    r += δr
    p1 = p2

#---------------------------------------------------------------------------------------------------

proc update(sim: Simulation): gboolean =
  ## Update the simulation state.

  result = gboolean(1)
  sim.draw(sim.area.window.cairoCreate())
  inc sim.itercount

#---------------------------------------------------------------------------------------------------

proc activate(app: Application) =
  ## Activate the application.

  let window = app.newApplicationWindow()
  window.setSizeRequest(Width, Height)
  window.setTitle("Polyspiral")

  let area = newDrawingArea()
  window.add(area)

  let sim = newSimulation(area, Width, Height)

  timeoutAdd(500, update, sim)

  window.showAll()

#———————————————————————————————————————————————————————————————————————————————————————————————————

let app = newApplication(Application, "Rosetta.polyspiral")
discard app.connect("activate", activate)
discard app.run()
