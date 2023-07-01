#include <stdio.h>
#include <math.h>
#include <string.h>

#define N 40
double x[N], y[N];

void minmax(double x[], int len, double *base, double *step, int *nstep)
{
	int i;
	double diff, minv, maxv;
	*step = 1;

	minv = maxv = x[0];
	for (i = 1; i < len; i++) {
		if (minv > x[i]) minv = x[i];
		if (maxv < x[i]) maxv = x[i];
	}
	if (minv == maxv) {
		minv = floor(minv);
		maxv =  ceil(maxv);
		if (minv == maxv) {
			minv--;
			maxv++;
		}
	} else {
		diff = maxv - minv;
		while (*step < diff) *step *= 10;
		while (*step > diff)	   *step /= 10;
		if (*step > diff / 2)	   *step /= 5;
		else if (*step > diff / 5) *step /= 2;
	}

	*base = floor(minv / *step) * *step;
	*nstep =  ceil(maxv / *step) - floor(minv / *step);
}

/* writes an eps with 400 x 300 dimention, using 12 pt font */
#define CHARH 12
#define CHARW 6
#define DIMX 398
#define DIMY (300 - CHARH)
#define BOTY 20.
int plot(double x[], double y[], int len, char *spec)
{
	int nx, ny, i;
	double sx, sy, x0, y0;
	char buf[100];
	int dx, dy, lx, ly;
	double ofs_x, ofs_y, grid_x;

	minmax(x, len, &x0, &sx, &nx);
	minmax(y, len, &y0, &sy, &ny);

	dx = -log10(sx);
	dy = -log10(sy);

	ly = 0;
	for (i = 0; i <= ny; i++) {
		sprintf(buf, "%g\n", y0 + i * sy);
		if (strlen(buf) > ly) ly = strlen(buf);
	}
	ofs_x = ly * CHARW;

	printf("%%!PS-Adobe-3.0\n%%%%BoundingBox: 0 0 400 300\n"
		"/TimesRoman findfont %d scalefont setfont\n"
		"/rl{rlineto}def /l{lineto}def /s{setrgbcolor}def "
		"/rm{rmoveto}def /m{moveto}def /st{stroke}def\n",
		CHARH);
	for (i = 0; i <= ny; i++) {
		ofs_y = BOTY + (DIMY - BOTY) / ny * i;
		printf("0 %g m (%*.*f) show\n",
			ofs_y - 4, ly, dy, y0 + i * sy);
		if (i) printf("%g %g m 7 0 rl st\n",
			ofs_x, ofs_y);
	}
	printf("%g %g m %g %g l st\n", ofs_x, BOTY, ofs_x, ofs_y);

	for (i = 0; i <= nx; i++) {
		sprintf(buf, "%g", x0 + i * sx);
		lx = strlen(buf);
		grid_x = ofs_x + (DIMX - ofs_x) / nx * i;

		printf("%g %g m (%s) show\n", grid_x - CHARW * lx / 2,
			BOTY - 12, buf);
		if (i) printf("%g %g m 0 7 rl st\n", grid_x, BOTY);
	}
	printf("%g %g m %g %g l st\n", ofs_x, BOTY, grid_x, BOTY);
		
	if (strchr(spec, 'r'))		printf("1 0 0 s\n");
	else if (strchr(spec, 'b'))	printf("0 0 1 s\n");
	else if (strchr(spec, 'g'))	printf("0 1 0 s\n");
	else if (strchr(spec, 'm'))	printf("1 0 1 s\n");

	if (strchr(spec, 'o'))
		printf("/o { m 0 3 rm 3 -3 rl -3 -3 rl -3 3 rl closepath st} def "
			".5 setlinewidth\n");

	if (strchr(spec, '-')) {
		for (i = 0; i < len; i++) {
			printf("%g %g %s ",
				(x[i] - x0) / (sx * nx) * (DIMX - ofs_x) + ofs_x,
				(y[i] - y0) / (sy * ny) * (DIMY - BOTY) + BOTY,
				i ? "l" : "m");
		}
		printf("st\n");
	}

	if (strchr(spec, 'o'))
		for (i = 0; i < len; i++) {
			printf("%g %g o ",
				(x[i] - x0) / (sx * nx) * (DIMX - ofs_x) + ofs_x,
				(y[i] - y0) / (sy * ny) * (DIMY - BOTY) + BOTY);
		}

	printf("showpage\n%%EOF");
	
	return 0;
}

int main()
{
	int i;
	for (i = 0; i < N; i++) {
		x[i] = (double)i / N * 3.14159 * 6;
		y[i] = -1337 + (exp(x[i] / 10) + cos(x[i])) / 100;
	}
	/* string parts: any of "rgbm": color; "-": draw line; "o": draw symbol */
	plot(x, y, N, "r-o");
	return 0;
}
