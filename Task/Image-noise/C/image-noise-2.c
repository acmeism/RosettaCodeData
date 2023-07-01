#include <GL/glut.h>
#include <GL/gl.h>
#include <stdio.h>
#include <time.h>

#define W 320
#define H 240
#define slen W * H / sizeof(int)

time_t start, last;

void render()
{
	static int frame = 0, bits[slen];
	register int i = slen, r;
	time_t t;

	r = bits[0] + 1;
	while (i--) r *= 1103515245, bits[i] = r ^ (bits[i] >> 16);

	glClear(GL_COLOR_BUFFER_BIT);
	glBitmap(W, H, 0, 0, 0, 0, (void*)bits);
	glFlush();

	if (!(++frame & 15)) {
		if ((t = time(0)) > last) {
			last = t;
			printf("\rfps: %ld  ", frame / (t - start));
			fflush(stdout);
		}
	}
}

int main(int argc, char **argv)
{
	glutInit(&argc, argv);
	glutInitDisplayMode(GLUT_INDEX);
	glutInitWindowSize(W, H);
	glutCreateWindow("noise");
	glutDisplayFunc(render);
	glutIdleFunc(render);

	last = start = time(0);

	glutMainLoop();
	return 0;
}
