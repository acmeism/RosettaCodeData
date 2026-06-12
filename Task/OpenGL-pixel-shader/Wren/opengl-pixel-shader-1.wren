/* OpenGL_pixel_shader.wren */

import "random" for Random

var GL_COLOR_BUFFER_BIT = 0x4000

var GL_TRIANGLES = 0x0004

var GL_VERTEX_SHADER = 0x8b31
var GL_FRAGMENT_SHADER = 0x8b30

var GLUT_ACTION_ON_WINDOW_CLOSE = 0x01f9
var GLUT_ACTION_GLUTMAINLOOP_RETURNS = 0x0001

var GLUT_DOUBLE = 0x0002
var GLUT_RGB    = 0x0000

var Rand = Random.new()

var Angle = 0
var R_mod = 0

class GL {
    foreign static clear(mask)

    foreign static uniform1f(location, v0)

    foreign static loadIdentity()

    foreign static rotatef(angle, x, y, z)

    foreign static begin(mode)

    foreign static vertex3f(x, y, z)

    foreign static end()

    foreign static createShader(shaderType)

    foreign static shaderSource(shader, count, string, length)

    foreign static compileShader(shader)

    foreign static createProgram()

    foreign static attachShader(program, shader)

    foreign static linkProgram(program)

    foreign static useProgram(program)

    foreign static getUniformLocation(program, name)
}

class Glut {
    foreign static initDisplayMode(mode)

    foreign static initWindowSize(width, height)

    foreign static createWindow(name)

    foreign static swapBuffers()

    foreign static idleFunc(clazz, signature)

    foreign static setOption(eWhat, value)
}

class Glew {
    foreign static init()

    foreign static isSupported(name)
}

class GLCallbacks {
    static render() {
        GL.clear(GL_COLOR_BUFFER_BIT)
	    GL.uniform1f(R_mod, Rand.float())
	    GL.loadIdentity()
	    GL.rotatef(Angle, Angle * 0.1, 1, 0)
	    GL.begin(GL_TRIANGLES)
		    GL.vertex3f(-1, -0.5, 0)
		    GL.vertex3f(0, 1, 0)
		    GL.vertex3f(1, 0, 0)
	    GL.end()
	    Angle = Angle + 0.02
	    Glut.swapBuffers()
    }
}

var setShader = Fn.new {
    var f =
"varying float x, y, z;
uniform float r_mod;
float rand(float s, float r) { return mod(mod(s, r + r_mod) * 112341.0, 1.0);}
void main() {
    gl_FragColor = vec4(rand(gl_FragCoord.x, x), rand(gl_FragCoord.y, y), rand(gl_FragCoord.z, z), 1.0);
}"

    var v =
"varying float x, y, z;
void main() {
gl_Position = ftransform();
x = gl_Position.x; y = gl_Position.y; z = gl_Position.z;
x += y; y -= x; z += x - y;
}"

    var vs = GL.createShader(GL_VERTEX_SHADER)
    var ps = GL.createShader(GL_FRAGMENT_SHADER)
    GL.shaderSource(ps, 1, f, null)
    GL.shaderSource(vs, 1, v, null)

    GL.compileShader(vs)
    GL.compileShader(ps)

    var prog = GL.createProgram()
    GL.attachShader(prog, ps)
    GL.attachShader(prog, vs)

    GL.linkProgram(prog)
    GL.useProgram(prog)
    R_mod = GL.getUniformLocation(prog, "r_mod")	
}

Glut.initDisplayMode(GLUT_DOUBLE | GLUT_RGB)
Glut.initWindowSize(200, 200)
Glut.createWindow("Stuff")
Glut.idleFunc("GLCallbacks", "render()")
Glew.init()
if (!Glew.isSupported("GL_VERSION_2_0")) {
    System.print("GL 2.0 unsupported\n")
    return
}
setShader.call()
Glut.setOption(GLUT_ACTION_ON_WINDOW_CLOSE, GLUT_ACTION_GLUTMAINLOOP_RETURNS)
