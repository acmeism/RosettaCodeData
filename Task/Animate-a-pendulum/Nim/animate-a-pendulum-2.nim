# Pendulum simulation.

import math
import times

import gintro/[gobject, gdk, gtk, gio, cairo]
import gintro/glib except Pi

type

  # Description of the simulation.
  Simulation = ref object
    area: DrawingArea       # Drawing area.
    length: float           # Pendulum length.
    g: float                # Gravity (should be positive).
    time: Time              # Current time.
    theta0: float           # initial angle.
    theta: float            # Current angle.
    omega: float            # Angular velocity = derivative of theta.
    accel: float            # Angular acceleration = derivative of omega.
    e: float                # Total energy.

#---------------------------------------------------------------------------------------------------

proc newSimulation(area: DrawingArea; length, g, theta0: float): Simulation {.noInit.} =
  ## Allocate and initialize the simulation object.

  new(result)
  result.area = area
  result.length = length
  result.g = g
  result.time = getTime()
  result.theta0 = theta0
  result.theta = theta0
  result.omega = 0
  result.accel = -g / length * sin(theta0)
  result.e = g * length * (1 - cos(theta0))    # Total energy = potential energy when starting.

#---------------------------------------------------------------------------------------------------

template toFloat(dt: Duration): float = dt.inNanoseconds.float / 1e9

#---------------------------------------------------------------------------------------------------

const Origin = (x: 320.0, y: 100.0)   # Pivot coordinates.
const Scale = 300                     # Coordinates scaling constant.

proc draw(sim: Simulation; context: cairo.Context) =
  ## Draw the pendulum.

  # Compute coordinates in drawing area.
  let x = Origin.x + sin(sim.theta) * Scale
  let y = Origin.y + cos(sim.theta) * Scale

  # Clear the region.
  context.moveTo(0, 0)
  context.setSource(0.0, 0.0, 0.0)
  context.paint()

  # Draw pendulum.
  context.moveTo(Origin.x, Origin.y)
  context.setSource(0.3, 1.0, 0.3)
  context.lineTo(x, y)
  context.stroke()

  # Draw pivot.
  context.setSource(0.3, 0.3, 1.0)
  context.arc(Origin.x, Origin.y, 8, 0, 2 * Pi)
  context.fill()

  # Draw mass.
  context.setSource(1.0, 0.3, 0.3)
  context.arc(x, y, 8, 0, 2 * Pi)
  context.fill()

#---------------------------------------------------------------------------------------------------

proc update(sim: Simulation): gboolean =
  ## Update the simulation state.

  # compute time interval.
  let nextTime = getTime()
  let dt = (nextTime - sim.time).toFloat
  sim.time = nextTime

  # Update theta and omega.
  sim.theta += (sim.omega + dt * sim.accel / 2) * dt
  sim.omega += sim.accel * dt

  # If, due to computation errors, potential energy is greater than total energy,
  # reset theta to ±theta0 and omega to 0.
  if sim.length * sim.g * (1 - cos(sim.theta)) >= sim.e:
    sim.theta = sgn(sim.theta).toFloat * sim.theta0
    sim.omega = 0

  # Compute acceleration.
  sim.accel = -sim.g / sim.length * sin(sim.theta)

  result = gboolean(1)

  sim.draw(sim.area.window.cairoCreate())

#---------------------------------------------------------------------------------------------------

proc activate(app: Application) =
  ## Activate the application.

  let window = app.newApplicationWindow()
  window.setSizeRequest(640, 480)
  window.setTitle("Pendulum simulation")

  let area = newDrawingArea()
  window.add(area)

  let sim = newSimulation(area, length = 5, g = 9.81, theta0 = PI / 3)

  timeoutAdd(10, update, sim)

  window.showAll()

#———————————————————————————————————————————————————————————————————————————————————————————————————

let app = newApplication(Application, "Rosetta.pendulum")
discard app.connect("activate", activate)
discard app.run()
