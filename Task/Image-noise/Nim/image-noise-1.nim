import times

import opengl
import opengl/glut

const
  W = 320
  H = 240
  SLen = W * H div sizeof(int)

var
  frame = 0
  bits: array[SLen, uint]
  last, start: Time

#---------------------------------------------------------------------------------------------------

proc render() {.cdecl.} =
  ## Render the window.

  var r = bits[0] + 1
  for i in countdown(bits.high, 0):
    r *= 1103515245
    bits[i] = r xor bits[i] shr 16

  glClear(GL_COLOR_BUFFER_BIT)
  glBitmap(W, H, 0, 0, 0, 0, cast[ptr GLubyte](bits.addr))
  glFlush()

  inc frame
  if (frame and 15) == 0:
    let t = getTime()
    if t > last:
      last = t
      echo "fps: ", frame.float / (t - start).inSeconds.float

#---------------------------------------------------------------------------------------------------

proc initGfx(argc: ptr cint; argv: pointer) =
  ## Initialize OpenGL rendering.

  glutInit(argc, argv)
  glutInitDisplayMode(GLUT_RGB)
  glutInitWindowSize(W, H)
  glutIdleFunc(render)
  discard glutCreateWindow("Noise")
  glutDisplayFunc(render)
  loadExtensions()

#———————————————————————————————————————————————————————————————————————————————————————————————————

var argc: cint = 0
initGfx(addr(argc), nil)
start = getTime()
last = start
glutMainLoop()
