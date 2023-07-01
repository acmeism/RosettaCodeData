# Pendulum simulation.

import math
import times

import opengl
import opengl/glut

var
  # Simulation variables.
  lg: float         # Pendulum length.
  g: float          # Gravity (should be positive).
  currTime: Time    # Current time.
  theta0: float     # Initial angle.
  theta: float      # Current angle.
  omega: float      # Angular velocity = derivative of theta.
  accel: float      # Angular acceleration = derivative of omega.
  e: float          # Total energy.

#---------------------------------------------------------------------------------------------------

proc initSimulation(length, gravitation, start: float) =
  ## Initialize the simulation.

  lg = length
  g = gravitation
  currTime = getTime()
  theta0 = start                    # Initial angle for which omega = 0.
  theta = start
  omega = 0
  accel = -g / lg * sin(theta0)
  e = g * lg * (1 - cos(theta0))    # Total energy = potential energy when starting.

#---------------------------------------------------------------------------------------------------

proc elapsed(): float =
  ## Return the elapsed time since previous call, expressed in seconds.

  let nextTime = getTime()
  result = (nextTime - currTime).inMicroseconds.float / 1e6
  currTime = nextTime

#---------------------------------------------------------------------------------------------------

proc resize(w, h: GLsizei) =
  ## Resize the window.

  glViewport(0, 0, w, h)
  glMatrixMode(GL_PROJECTION)
  glLoadIdentity()

  glMatrixMode(GL_MODELVIEW)
  glLoadIdentity()
  glOrtho(0, GLdouble(w), GLdouble(h), 0, -1, 1)

#---------------------------------------------------------------------------------------------------

proc render() {.cdecl.} =
  ## Render the window.

  # Compute the position of the mass.
  var x = 320 + 300 * sin(theta)
  var y = 300 * cos(theta)

  resize(640, 320)
  glClear(GL_COLOR_BUFFER_BIT)

  # Draw the line from pivot to mass.
  glBegin(GL_LINES)
  glVertex2d(320, 0)
  glVertex2d(x, y)
  glEnd()
  glFlush()

  # Update theta and omega.
  let dt = elapsed()
  theta += (omega + dt * accel / 2) * dt
  omega += accel * dt

  # If, due to computation errors, potential energy is greater than total energy,
  # reset theta to ±theta0 and omega to 0.
  if lg * g * (1 - cos(theta)) >= e:
    theta = sgn(theta).toFloat * theta0
    omega = 0

  accel = -g / lg * sin(theta)

#---------------------------------------------------------------------------------------------------

proc initGfx(argc: ptr cint; argv: pointer) =
  ## Initialize OpenGL rendering.

  glutInit(argc, argv)
  glutInitDisplayMode(GLUT_RGB)
  glutInitWindowSize(640, 320)
  glutIdleFunc(render)
  discard glutCreateWindow("Pendulum")
  glutDisplayFunc(render)
  loadExtensions()

#———————————————————————————————————————————————————————————————————————————————————————————————————

initSimulation(length = 5, gravitation = 9.81, start = PI / 3)

var argc: cint = 0
initGfx(addr(argc), nil)
glutMainLoop()
