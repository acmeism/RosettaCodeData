import pygame
from OpenGL.GL import *
from OpenGL.GLU import *

WIDTH = 800
HEIGHT = 600

def draw_cube(size: float | int):
    glBegin(GL_QUADS)

    glColor3f(0.5, 0.5, 0.5)
    glVertex3f(-size, -size, size)
    glVertex3f(size, -size, size)
    glVertex3f(size, size, size)
    glVertex3f(-size, size, size)

    glColor3f(0.7, 0.7, 0.7)
    glVertex3f(-size, -size, -size)
    glVertex3f(-size, size, -size)
    glVertex3f(size, size, -size)
    glVertex3f(size, -size, -size)

    glColor3f(0.8, 0.8, 0.8)
    glVertex3f(-size, size, -size)
    glVertex3f(-size, size, size)
    glVertex3f(size, size, size)
    glVertex3f(size, size, -size)

    glColor3f(0.6, 0.6, 0.6)
    glVertex3f(-size, -size, -size)
    glVertex3f(size, -size, -size)
    glVertex3f(size, -size, size)
    glVertex3f(-size, -size, size)

    glColor3f(0.65, 0.65, 0.65)
    glVertex3f(size, -size, -size)
    glVertex3f(size, size, -size)
    glVertex3f(size, size, size)
    glVertex3f(size, -size, size)

    glColor3f(0.55, 0.55, 0.55)
    glVertex3f(-size, -size, -size)
    glVertex3f(-size, -size, size)
    glVertex3f(-size, size, size)
    glVertex3f(-size, size, -size)

    glEnd()

def draw_pyramid(size: float | int):
    glBegin(GL_TRIANGLES)

    glColor3f(0.8, 0.2, 0.2)
    glVertex3f(0, size, 0)
    glVertex3f(-size, -size, size)
    glVertex3f(size, -size, size)

    glColor3f(0.9, 0.3, 0.3)
    glVertex3f(0, size, 0)
    glVertex3f(size, -size, size)
    glVertex3f(size, -size, -size)

    glColor3f(0.7, 0.1, 0.1)
    glVertex3f(0, size, 0)
    glVertex3f(size, -size, -size)
    glVertex3f(-size, -size, -size)

    glColor3f(0.6, 0.0, 0.0)
    glVertex3f(0, size, 0)
    glVertex3f(-size, -size, -size)
    glVertex3f(-size, -size, size)

    glEnd()

def main():
    pygame.init()
    pygame.display.set_caption("3d turtle graphics")
    pygame.display.set_mode((WIDTH, HEIGHT), pygame.DOUBLEBUF | pygame.OPENGL)

    glViewport(0, 0, WIDTH, HEIGHT)
    glMatrixMode(GL_PROJECTION)
    glLoadIdentity()
    gluPerspective(45.0, WIDTH / HEIGHT, 0.1, 100.0)

    glMatrixMode(GL_MODELVIEW)
    glLoadIdentity()
    glTranslatef(0.0, 0.0, -20.0)
    glRotatef(20.0, 1.0, 0.0, 0.0)
    glRotatef(-30.0, 0.0, 1.0, 0.0)

    glEnable(GL_DEPTH_TEST)

    rotation = 0

    running = True

    while running:
        for event in pygame.event.get():
            if event.type == pygame.QUIT or (event.type == pygame.KEYDOWN and event.key == pygame.K_ESCAPE):
                running = False

        glClear(GL_COLOR_BUFFER_BIT | GL_DEPTH_BUFFER_BIT)
        glLoadIdentity()
        glTranslatef(0.0, 0.0, -20.0)
        glRotatef(20.0, 1.0, 0.0, 0.0)
        glRotatef(rotation, 0.0, 1.0, 0.0)

        glPushMatrix()
        glTranslatef(-5.0, -2.0, 0.0)
        glScalef(1.5, 1.0, 1.0)
        draw_cube(1.0)
        glTranslatef(0.0, 1.5, 0.0)
        glScalef(1.0, 0.5, 1.0)
        draw_pyramid(1.0)
        glPopMatrix()

        bar_heights = [1.0, 1.5, 0.8, 2.0, 1.2]

        for i in range(5):
            glPushMatrix()
            glTranslatef(i * 1.5 - 1.0, bar_heights[i] / 2 - 2.0, 3.0)
            glScalef(0.5, bar_heights[i] / 2, 0.5)
            draw_cube(1.0)
            glPopMatrix()

        pygame.display.flip()
        pygame.time.wait(10)
        rotation += 0.5

    pygame.quit()

if __name__ == "__main__":
    main()
