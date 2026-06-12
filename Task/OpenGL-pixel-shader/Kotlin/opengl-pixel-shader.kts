// Kotlin Native v0.6

import kotlinx.cinterop.*
import opengl2.*

var rMod = 0
var angle = 0f

fun render() {
    glClear(GL_COLOR_BUFFER_BIT)
    __glewUniform1f!!(rMod, rand() / RAND_MAX.toFloat())
    glLoadIdentity()
    glRotatef(angle, angle * 0.1f, 1f, 0f)
    glBegin(GL_TRIANGLES)
    glVertex3f(-1f, -0.5f, 0f)
    glVertex3f(0f, 1f, 0f)
    glVertex3f(1f, 0f, 0f)
    glEnd()
    angle += 0.02f
    glutSwapBuffers()
}

fun setShader() {
    val f =
        "varying float x, y, z;" +
        "uniform float r_mod;" +
        "float rand(float s, float r) { return mod(mod(s, r + r_mod) * 112341, 1); }" +
        "void main() {" +
        "	 gl_FragColor = vec4(rand(gl_FragCoord.x, x), " +
        "rand(gl_FragCoord.y, y), rand(gl_FragCoord.z, z), 1);" +
        "}"

    val v =
        "varying float x, y, z;" +
        "void main() {" +
        "   gl_Position = ftransform();" +
        "   x = gl_Position.x; y = gl_Position.y; z = gl_Position.z;" +
        "   x += y; y -= x; z += x - y;" +
        "}"

    val vs = __glewCreateShader!!(GL_VERTEX_SHADER)
    val ps = __glewCreateShader!!(GL_FRAGMENT_SHADER)


    memScoped {
        val fp = allocPointerTo<ByteVar>()
        fp.value = f.cstr.getPointer(memScope)
        __glewShaderSource!!(ps, 1, fp.ptr, null)
        val vp = allocPointerTo<ByteVar>()
        vp.value = v.cstr.getPointer(memScope)
        __glewShaderSource!!(vs, 1, vp.ptr, null)

        __glewCompileShader!!(vs)
        __glewCompileShader!!(ps)

        val prog = __glewCreateProgram!!()
        __glewAttachShader!!(prog, ps)
        __glewAttachShader!!(prog, vs)

        __glewLinkProgram!!(prog)
        __glewUseProgram!!(prog)

        val sp = allocPointerTo<ByteVar>()
        sp.value = "r_mod".cstr.getPointer(memScope)
        rMod = __glewGetUniformLocation!!(prog, sp.value)
    }
}

fun main(args: Array<String>) {
    memScoped {
        val argc = alloc<IntVar>().apply { value = 0 }
        glutInit(argc.ptr, null)
    }
    glutInitDisplayMode(GLUT_DOUBLE or GLUT_RGB)
    glutInitWindowSize(200, 200)
    glutCreateWindow("Stuff")
    glutIdleFunc(staticCFunction(::render))
    glewInit()
    if (glewIsSupported("GL_VERSION_2_0") == 0.toByte()) {
        println("GL 2.0 unsupported\n")
        return
    }
    setShader()
    glutMainLoop()
}
