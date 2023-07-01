/* opengl.wren */

var GL_COLOR_BUFFER_BIT = 0x4000
var GL_DEPTH_BUFFER_BIT = 0x0100

var GL_SMOOTH = 0x1d01
var GL_MODELVIEW = 0x1700
var GL_PROJECTION = 0x1701

var GL_TRIANGLES = 0x0004

var GLUT_ACTION_ON_WINDOW_CLOSE = 0x01f9
var GLUT_ACTION_GLUTMAINLOOP_RETURNS = 0x0001

class GL {
    foreign static clearColor(red, green, blue, alpha)

    foreign static clear(mask)

    foreign static shadeModel(mode)

    foreign static loadIdentity()

    foreign static translatef(x, y, z)

    foreign static begin(mode)

    foreign static color3f(red, green, blue)

    foreign static vertex2f(x, y)

    foreign static end()

    foreign static flush()

    foreign static viewport(x, y, width, height)

    foreign static matrixMode(mode)

    foreign static ortho(left, right, bottom, top, nearVal, farVal)
}

class Glut {
    foreign static initWindowSize(width, height)

    foreign static createWindow(name)

    foreign static displayFunc(clazz, signature)

    foreign static reshapeFunc(clazz, signature)

    foreign static setOption(eWhat, value)
}

class GLCallbacks {
    static paint() {
        GL.clearColor(0.3, 0.3, 0.3, 0)
        GL.clear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
        GL.shadeModel(GL_SMOOTH)
        GL.loadIdentity()
        GL.translatef(-15, -15, 0)
        GL.begin(GL_TRIANGLES)
        GL.color3f(1, 0, 0)
        GL.vertex2f(0, 0)
        GL.color3f(0, 1, 0)
        GL.vertex2f(30, 0)
        GL.color3f(0, 0, 1)
        GL.vertex2f(0, 30)
        GL.end()
        GL.flush()
    }

    static reshape(width, height) {
        GL.viewport(0, 0, width, height)
        GL.matrixMode(GL_PROJECTION)
        GL.loadIdentity()
        GL.ortho(-30, 30, -30, 30, -30, 30)
        GL.matrixMode(GL_MODELVIEW)
    }
}

Glut.initWindowSize(640, 480)
Glut.createWindow("Triangle")
Glut.displayFunc("GLCallbacks", "paint()")
Glut.reshapeFunc("GLCallbacks", "reshape(_,_)")
Glut.setOption(GLUT_ACTION_ON_WINDOW_CLOSE, GLUT_ACTION_GLUTMAINLOOP_RETURNS)
