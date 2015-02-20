#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <sys/time.h>

#define PI 3.14159265
const char * shades = " .:-*ca&#%@";

/* distance of (x, y) from line segment (0, 0)->(x0, y0) */
double dist(double x, double y, double x0, double y0) {
	double l = (x * x0 + y * y0) / (x0 * x0 + y0 * y0);

	if (l > 1) {
		x -= x0;
		y -= y0;
	} else if (l >= 0) {
		x -= l * x0;
		y -= l * y0;
	}
	return sqrt(x * x + y * y);
}

enum { sec = 0, min, hur }; // for subscripts

void draw(int size)
{
#	define for_i for(int i = 0; i < size; i++)
#	define for_j for(int j = 0; j < size * 2; j++)

	double angle, cx = size / 2.;
	double sx[3], sy[3], sw[3];
	double fade[] = { 1, .35, .35 }; /* opacity of each arm */
	struct timeval tv;
	struct tm *t;

	/* set width of each arm */
	sw[sec] = size * .02;
	sw[min] = size * .03;
	sw[hur] = size * .05;

every_second:
	gettimeofday(&tv, 0);
	t = localtime(&tv.tv_sec);

	angle = t->tm_sec * PI / 30;
	sy[sec] = -cx * cos(angle);
	sx[sec] =  cx * sin(angle);

	angle = (t->tm_min + t->tm_sec / 60.) / 30 * PI;
	sy[min] = -cx * cos(angle) * .8;
	sx[min] =  cx * sin(angle) * .8;

	angle = (t->tm_hour + t->tm_min / 60.) / 6 * PI;
	sy[hur] = -cx * cos(angle) * .6;
	sx[hur] =  cx * sin(angle) * .6;

	printf("\033[s"); /* save cursor position */
	for_i {
		printf("\033[%d;0H", i);  /* goto row i, col 0 */
		double y = i - cx;
		for_j {
			double x = (j - 2 * cx) / 2;

			int pix = 0;
			/* calcs how far the "pixel" is from each arm and set
			 * shade, with some anti-aliasing.  It's ghetto, but much
			 * easier than a real scanline conversion.
			 */
			for (int k = hur; k >= sec; k--) {
				double d = dist(x, y, sx[k], sy[k]);
				if (d < sw[k] - .5)
					pix = 10 * fade[k];
				else if (d < sw[k] + .5)
					pix = (5 + (sw[k] - d) * 10) * fade[k];
			}
			putchar(shades[pix]);
		}
	}
	printf("\033[u"); /* restore cursor pos so you can bg the job -- value unclear */

	fflush(stdout);
	sleep(1); /* sleep 1 can at times miss a second, but will catch up next update */
	goto every_second;
}

int main(int argc, char *argv[])
{
	int s;
	if (argc <= 1 || (s = atoi(argv[1])) <= 0) s = 20;
	draw(s);
	return 0;
}
