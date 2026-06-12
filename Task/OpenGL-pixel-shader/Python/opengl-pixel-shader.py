import random

from OpenGL.GL import *
from OpenGL.GLUT import *

RAND_MAX = 0x7FFF
angle = 0
r_mod = None


def render():
    global angle

    glClear(GL_COLOR_BUFFER_BIT)
    glUniform1f(r_mod, random.random() / RAND_MAX)
    glLoadIdentity()
    glRotatef(angle, angle * 0.1, 1, 0)

    glBegin(GL_TRIANGLES)
    glVertex3f(-1, -0.5, 0)
    glVertex3f(0, 1, 0)
    glVertex3f(1, 0, 0)
    glEnd()

    angle += 0.02

    glutSwapBuffers()


def set_shader():
    f = """
        varying float x, y, z;
        uniform float r_mod;
        float rand(float s, float r) { return mod(mod(s, r + r_mod) * 112341.0, 1.0); }
        void main() {
            gl_FragColor = vec4(rand(gl_FragCoord.x, x), rand(gl_FragCoord.y, y), rand(gl_FragCoord.z, z), 1.0);
        }
    """

    v = """
        varying float x, y, z;
        void main() {
            gl_Position = ftransform();
            x = gl_Position.x; y = gl_Position.y; z = gl_Position.z;
            x += y; y -= x; z += x - y;
        }
    """

    vs = glCreateShader(GL_VERTEX_SHADER)
    ps = glCreateShader(GL_FRAGMENT_SHADER)

    glShaderSource(ps, f)
    glShaderSource(vs, v)

    glCompileShader(vs)
    glCompileShader(ps)

    prog = glCreateProgram()

    glAttachShader(prog, ps)
    glAttachShader(prog, vs)

    glLinkProgram(prog)
    glUseProgram(prog)

    global r_mod
    r_mod = glGetUniformLocation(prog, "r_mod")


def main():
    glutInit(1, 1)
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB)
    glutInitWindowSize(200, 200)
    glutCreateWindow("Stuff")
    glutIdleFunc(render)

    set_shader()
    glutMainLoop()


if __name__ == "__main__":
    main()
