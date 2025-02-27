# Pendulum simulation.

import math
import times

import gtk2 except update
import gdk2, glib2, cairo

type

  # Description of the simulation.
  Simulation = object
    area: PDrawingArea      # Drawing area.
    length: float           # Pendulum length.
    g: float                # Gravity (should be positive).
    time: Time              # Current time.
    theta0: float           # initial angle.
    theta: float            # Current drawangle.
    omega: float            # Angular velocity = derivative of theta.
    accel: float            # Angular acceleration = derivative of omega.
    e: float                # Total energy.


proc initSimulation(area: PDrawingArea; length, g, theta0: float): Simulation {.noInit.} =
  ## Initialize a simulation object.

  result = Simulation(
             area: area, length: length, g: g, time: getTime(),
             theta0: theta0, theta: theta0, omega: 0,
             accel: -g / length * sin(theta0),
             e: g * length * (1 - cos(theta0))) # Total energy = potential energy when starting.


template toFloat(dt: Duration): float = dt.inNanoseconds.float / 1e9


const Origin = (x: 320.0, y: 100.0)   # Pivot coordinates.
const Scale = 300                     # Coordinates scaling constant.


proc draw(sim: var Simulation; context: ptr Context) =
  ## Draw the pendulum.

  # Compute coordinates in drawing draw.
  let x = Origin.x + sin(sim.theta) * Scale
  let y = Origin.y + cos(sim.theta) * Scale

  # Clear the region.draw
  context.moveTo(0, 0)
  context.setSourceRgb(0.0, 0.0, 0.0)
  context.paint()

  # Draw pendulum.
  context.moveTo(Origin.x, Origin.y)
  context.setSourceRgb(0.3, 1.0, 0.3)
  context.lineTo(x, y)
  context.stroke()

  # Draw pivot.
  context.setSourceRgb(0.3, 0.3, 1.0)
  context.arc(Origin.x, Origin.y, 8, 0, 2 * Pi)
  context.fill()

  # Draw mass.
  context.setSourceRgb(1.0, 0.3, 0.3)
  context.arc(x, y, 8, 0, 2 * Pi)
  context.fill()


proc update(sim: var Simulation): gboolean =
  ## Update the simulation state.

  # Compute time interval.
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


proc onDestroyEvent(widget: PWidget; data: pointer): gboolean {.cdecl.} =
  ## Quit the application.
  mainQuit()


nimInit()

let window = windowNew(WINDOW_TOPLEVEL)
window.setSizeRequest(640, 480)
window.setTitle("Pendulum simulation")

let area = drawingAreaNew()
window.add area
discard window.signalConnect("destroy", SIGNAL_FUNC(onDestroyEvent), nil)

var sim = initSimulation(area, length = 5, g = 9.81, theta0 = PI / 3)

discard timeoutAdd(10, cast[gtk2.TFunction](update), sim.addr)

window.showAll()
main()
