import glut

var win: int = 0

proc myOnKeyPress(c: int8, v1, v2: cint) {.cdecl.} =
   echo(c)
   if c == 27:
      glutDestroyWindow(win)

glutInit()
win = glutCreateWindow("Goodbye, World!")
glutKeyboardFunc(TGlut1Char2IntCallback(myOnKeyPress))
glutMainLoop()
