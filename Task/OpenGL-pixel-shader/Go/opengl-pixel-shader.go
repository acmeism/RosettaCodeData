package main

/*
#cgo LDFLAGS: -lglut -lGLEW -lGL -lGLU
#include <stdlib.h>
#include <GL/glew.h>
#include <GL/glut.h>

extern void render();

typedef void (*callback) ();

static inline callback idleFunc() {
    return render;
}

static inline void glUniform1f_macro(GLint location, GLfloat v0) {
    glUniform1f(location, v0);
}

static inline GLuint glCreateShader_macro(GLenum _type) {
    return glCreateShader(_type);
}

static inline void glShaderSource_macro(GLuint shader, GLsizei count, const GLchar *const* string, const GLint* length) {
    glShaderSource(shader, count, string, length);
}

static inline void glCompileShader_macro(GLuint shader) {
    glCompileShader(shader);
}

static inline GLuint glCreateProgram_macro() {
    return glCreateProgram();
}

static inline void glAttachShader_macro(GLuint program, GLuint shader) {
    glAttachShader(program, shader);
}

static inline void glLinkProgram_macro(GLuint program) {
    glLinkProgram(program);
}

static inline void glUseProgram_macro(GLuint program) {
    glUseProgram(program);
}

static inline GLint glGetUniformLocation_macro(GLuint program, const GLchar* name) {
    return glGetUniformLocation(program, name);
}

*/
import "C"
import "log"
import "unsafe"

var ps, vs, prog, r_mod C.GLuint
var angle = float32(0)

//export render
func render() {
    C.glClear(C.GL_COLOR_BUFFER_BIT)
    C.glUniform1f_macro(C.GLint(r_mod), C.GLfloat(C.rand())/C.GLfloat(C.RAND_MAX))
    C.glLoadIdentity()
    C.glRotatef(C.float(angle), C.float(angle*0.1), 1, 0)
    C.glBegin(C.GL_TRIANGLES)
    C.glVertex3f(-1, -0.5, 0)
    C.glVertex3f(0, 1, 0)
    C.glVertex3f(1, 0, 0)
    C.glEnd()
    angle += 0.02
    C.glutSwapBuffers()
}

func setShader() {
    f := "varying float x, y, z;" +
        "uniform float r_mod;" +
        "float rand(float s, float r) { return mod(mod(s, r + r_mod) * 112341.0, 1.0); }" +
        "void main() {" +
        "    gl_FragColor = vec4(rand(gl_FragCoord.x, x), rand(gl_FragCoord.y, y), rand(gl_FragCoord.z, z), 1.0);" +
        "}"

    v := "varying float x, y, z;" +
        "void main() {" +
        "    gl_Position = ftransform();" +
        "    x = gl_Position.x; y = gl_Position.y; z = gl_Position.z;" +
        "    x += y; y -= x; z += x - y;" +
        "}"

    fc, vc := C.CString(f), C.CString(v)
    defer C.free(unsafe.Pointer(fc))
    defer C.free(unsafe.Pointer(vc))

    vs = C.glCreateShader_macro(C.GL_VERTEX_SHADER)
    ps = C.glCreateShader_macro(C.GL_FRAGMENT_SHADER)
    C.glShaderSource_macro(ps, 1, &fc, nil)
    C.glShaderSource_macro(vs, 1, &vc, nil)

    C.glCompileShader_macro(vs)
    C.glCompileShader_macro(ps)

    prog = C.glCreateProgram_macro()
    C.glAttachShader_macro(prog, ps)
    C.glAttachShader_macro(prog, vs)

    C.glLinkProgram_macro(prog)
    C.glUseProgram_macro(prog)
    rms := C.CString("r_mod")
    r_mod = C.GLuint(C.glGetUniformLocation_macro(prog, rms))
    C.free(unsafe.Pointer(rms))
}

func main() {
    argc := C.int(0)
    C.glutInit(&argc, nil)
    C.glutInitDisplayMode(C.GLUT_DOUBLE | C.GLUT_RGB)
    C.glutInitWindowSize(200, 200)
    tl := "Pixel Shader"
    tlc := C.CString(tl)
    C.glutCreateWindow(tlc)
    defer C.free(unsafe.Pointer(tlc))
    C.glutIdleFunc(C.idleFunc())

    C.glewInit()
    glv := C.CString("GL_VERSION_2_0")
    if C.glewIsSupported(glv) == 0 {
        log.Fatal("GL 2.0 unsupported")
    }
    defer C.free(unsafe.Pointer(glv))

    setShader()
    C.glutMainLoop()
}
