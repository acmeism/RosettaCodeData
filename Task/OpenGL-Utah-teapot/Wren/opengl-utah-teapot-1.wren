/* OpenGL_Utah_teapot.wren */

var Rot = 0
var MatCol = [1, 0, 0, 0]

var GL_COLOR_BUFFER_BIT = 0x4000
var GL_DEPTH_BUFFER_BIT = 0x0100

var GL_SMOOTH     = 0x1d01
var GL_FRONT      = 0x0404
var GL_DIFFUSE    = 0x1201
var GL_LIGHT0     = 0x4000
var GL_AMBIENT    = 0x1200
var GL_LIGHTING   = 0x0b50
var GL_SHININESS  = 0x1601
var GL_DEPTH_TEST = 0x0B71

var GLUT_SINGLE = 0x0000
var GLUT_RGB    = 0x0000
var GLUT_DEPTH  = 0x0010

var GLUT_ACTION_ON_WINDOW_CLOSE = 0x01f9
var GLUT_ACTION_GLUTMAINLOOP_RETURNS = 0x0001

class GL {
    foreign static clearColor(red, green, blue, alpha)

    foreign static clear(mask)

    foreign static shadeModel(mode)

    foreign static pushMatrix()

    foreign static rotatef(angle, x, y, z)

    foreign static materialfv(face, pname, params)

    foreign static popMatrix()

    foreign static flush()

    foreign static lightfv(light, pname, params)

    foreign static enable(cap)
}

class Glut {
    foreign static initDisplayMode(mode)

    foreign static initWindowSize(width, height)

    foreign static createWindow(name)

    foreign static displayFunc(clazz, method)

    foreign static idleFunc(clazz, method)

    foreign static postRedisplay()

    foreign static wireTeapot(dSize)

    foreign static setOption(eWhat, value)
}

class GLCallbacks {
    static display() {
        GL.clear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
	    GL.pushMatrix()
	    GL.rotatef(30, 1, 1, 0)
	    GL.rotatef(Rot, 0, 1, 1)
	    GL.materialfv(GL_FRONT, GL_DIFFUSE, MatCol)
	    Glut.wireTeapot(0.5)
	    GL.popMatrix()
	    GL.flush()
    }

    static onIdle() {
        Rot = Rot + 0.01
        Glut.postRedisplay()
    }
}

var init = Fn.new {
    var white = [1, 1, 1, 0]
    var shini = [70]

    GL.clearColor(0.5, 0.5, 0.5, 0)
	GL.shadeModel(GL_SMOOTH)
	GL.lightfv(GL_LIGHT0, GL_AMBIENT, white)
	GL.lightfv(GL_LIGHT0, GL_DIFFUSE, white)
	GL.materialfv(GL_FRONT, GL_SHININESS, shini)
	GL.enable(GL_LIGHTING)
	GL.enable(GL_LIGHT0)
	GL.enable(GL_DEPTH_TEST)
}

Glut.initDisplayMode(GLUT_SINGLE | GLUT_RGB | GLUT_DEPTH)
Glut.initWindowSize(900, 700)
Glut.createWindow("The Amazing, Rotating Utah Teapot brought to you in OpenGL via freeglut.")
init.call()
Glut.displayFunc("GLCallbacks", "display()")
Glut.idleFunc("GLCallbacks", "onIdle()")
Glut.setOption(GLUT_ACTION_ON_WINDOW_CLOSE, GLUT_ACTION_GLUTMAINLOOP_RETURNS)
