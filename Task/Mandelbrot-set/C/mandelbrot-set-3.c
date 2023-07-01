#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>
#include <GL/glut.h>
#include <GL/gl.h>
#include <GL/glu.h>

void set_texture();

unsigned char *tex;
int gwin;
GLuint texture;
int width, height;
int old_width, old_height;
double scale = 1. / 256;
double cx = -.6, cy = 0;
int color_rotate = 0;
int saturation = 1;
int invert = 0;
int max_iter = 256;

void render()
{
    glTexEnvi(GL_TEXTURE_ENV, GL_TEXTURE_ENV_MODE, GL_REPLACE);

    glBindTexture(GL_TEXTURE_2D, texture);

    glBegin(GL_QUADS);

    glTexCoord2d(0, 0);
    glVertex2i(0, 0);
    glTexCoord2d(1, 0);
    glVertex2i(width, 0);
    glTexCoord2d(1, 1);
    glVertex2i(width, height);
    glTexCoord2d(0, 1);
    glVertex2i(0, height);

    glEnd();

    glFlush();
    glFinish();
}

int dump = 1;
void screen_dump()
{
    char fn[100];
    sprintf(fn, "screen%03d.ppm", dump++);
    FILE *fp = fopen(fn, "w");
    fprintf(fp, "P6\n%d %d\n255\n", width, height);
    for (int i = height - 1; i >= 0; i -= 1) {
        for (int j = 0; j < width; j += 1) {
            fwrite(&tex[((i * width) + j) * 4], 1, 3, fp);
        }
    }
    fclose(fp);
    printf("%s written\n", fn);
}

void keypress(unsigned char key,[[maybe_unused]]
              int x,[[maybe_unused]]
              int y)
{
    switch (key) {
    case 'q':
        glFinish();
        glutDestroyWindow(gwin);
        break;

    case 27:
        scale = 1. / 256;
        cx = -.6;
        cy = 0;
        set_texture();
        break;

    case 'r':
        color_rotate = (color_rotate + 1) % 6;
        set_texture();
        break;

    case '>':
    case '.':
        max_iter += 128;
        if (max_iter > 1 << 15)
            max_iter = 1 << 15;
        printf("max iter: %d\n", max_iter);
        set_texture();
        break;

    case '<':
    case ',':
        max_iter -= 128;
        if (max_iter < 128)
            max_iter = 128;
        printf("max iter: %d\n", max_iter);
        set_texture();
        break;

    case 'c':
        saturation = 1 - saturation;
        set_texture();
        break;

    case 's':
        screen_dump();
        break;

    case 'z':
        max_iter = 4096;
        set_texture();
        break;

    case 'x':
        max_iter = 128;
        set_texture();
        break;

    case ' ':
        invert = !invert;
        set_texture();
        break;

    default:
        set_texture();
        break;
    }
}

#define VAL 255

void hsv_to_rgba(int hue, int min, int max, unsigned char *px)
{
    unsigned char r;
    unsigned char g;
    unsigned char b;

    if (min == max)
        max = min + 1;
    if (invert)
        hue = max - (hue - min);
    if (!saturation) {
        r = 255 * (max - hue) / (max - min);
        g = r;
        b = r;
    } else {
        double h =
            fmod(color_rotate + 1e-4 + 4.0 * (hue - min) / (max - min), 6);
        double c = VAL * saturation;
        double X = c * (1 - fabs(fmod(h, 2) - 1));

        r = 0;
        g = 0;
        b = 0;

        switch ((int) h) {
        case 0:
            r = c;
            g = X;
            break;
        case 1:
            r = X;
            g = c;
            break;
        case 2:
            g = c;
            b = X;
            break;
        case 3:
            g = X;
            b = c;
            break;
        case 4:
            r = X;
            b = c;
            break;
        default:
            r = c;
            b = X;
            break;
        }
    }

    /* Using an alpha channel neatly solves the problem of aligning
     * rows on 4-byte boundaries (at the expense of memory, of
     * course). */
    px[0] = r;
    px[1] = g;
    px[2] = b;
    px[3] = 255;                /* Alpha channel. */
}

void calc_mandel()
{
    int i, j, iter, min, max;
    double x, y, zx, zy, zx2, zy2;
    unsigned short *hsv = malloc(width * height * sizeof(unsigned short));

    min = max_iter;
    max = 0;
    for (i = 0; i < height; i++) {
        y = (i - height / 2) * scale + cy;
        for (j = 0; j < width; j++) {
            x = (j - width / 2) * scale + cx;
            iter = 0;

            zx = hypot(x - .25, y);
            if (x < zx - 2 * zx * zx + .25)
                iter = max_iter;
            if ((x + 1) * (x + 1) + y * y < 1 / 16)
                iter = max_iter;

            zx = 0;
            zy = 0;
            zx2 = 0;
            zy2 = 0;
            while (iter < max_iter && zx2 + zy2 < 4) {
                zy = 2 * zx * zy + y;
                zx = zx2 - zy2 + x;
                zx2 = zx * zx;
                zy2 = zy * zy;
                iter += 1;
            }
            if (iter < min)
                min = iter;
            if (iter > max)
                max = iter;
            hsv[(i * width) + j] = iter;
        }
    }

    for (i = 0; i < height; i += 1) {
        for (j = 0; j < width; j += 1) {
            unsigned char *px = tex + (((i * width) + j) * 4);
            hsv_to_rgba(hsv[(i * width) + j], min, max, px);
        }
    }

    free(hsv);
}

void alloc_tex()
{
    if (tex == NULL || width != old_width || height != old_height) {
        free(tex);
        tex = malloc(height * width * 4 * sizeof(unsigned char));
        memset(tex, 0, height * width * 4 * sizeof(unsigned char));
        old_width = width;
        old_height = height;
    }
}

void set_texture()
{
    alloc_tex();
    calc_mandel();

    glEnable(GL_TEXTURE_2D);
    glBindTexture(GL_TEXTURE_2D, texture);
    glTexImage2D(GL_TEXTURE_2D, 0, GL_RGBA, width, height,
                 0, GL_RGBA, GL_UNSIGNED_BYTE, tex);

    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST);
    glTexParameteri(GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST);

    render();
}

void mouseclick(int button, int state, int x, int y)
{
    if (state != GLUT_UP)
        return;

    cx += (x - width / 2) * scale;
    cy -= (y - height / 2) * scale;

    switch (button) {
    case GLUT_LEFT_BUTTON:     /* zoom in */
        if (scale > fabs((double) x) * 1e-16
            && scale > fabs((double) y) * 1e-16)
            scale /= 2;
        break;
    case GLUT_RIGHT_BUTTON:    /* zoom out */
        scale *= 2;
        break;
        /* any other button recenters */
    }
    set_texture();
}


void resize(int w, int h)
{
    printf("resize %d %d\n", w, h);

    width = w;
    height = h;

    glViewport(0, 0, w, h);
    glOrtho(0, w, 0, h, -1, 1);

    set_texture();
}

void init_gfx(int *c, char **v)
{
    glutInit(c, v);
    glutInitDisplayMode(GLUT_RGBA);
    glutInitWindowSize(640, 480);

    gwin = glutCreateWindow("Mandelbrot");
    glutDisplayFunc(render);

    glutKeyboardFunc(keypress);
    glutMouseFunc(mouseclick);
    glutReshapeFunc(resize);
    glGenTextures(1, &texture);
    set_texture();
}

int main(int c, char **v)
{
    tex = NULL;

    init_gfx(&c, v);
    printf
        ("keys:\n\tr: color rotation\n\tc: monochrome\n\ts: screen dump\n\t"
         "<, >: decrease/increase max iteration\n\tq: quit\n\tmouse buttons to zoom\n");

    glutMainLoop();
    return 0;
}

// local variables:
// mode: C
// c-file-style: "k&r"
// c-basic-offset: 4
// end:
