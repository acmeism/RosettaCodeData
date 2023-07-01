#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <string.h>

void hue_to_rgb(double hue, double sat, unsigned char *p)
{
	double x;
	int c = 255 * sat;
	hue /= 60;
	x = (1 - fabs(fmod(hue, 2) - 1)) * 255;

	switch((int)hue) {
	case 0:	p[0] = c; p[1] = x; p[2] = 0; return;
	case 1:	p[0] = x; p[1] = c; p[2] = 0; return;
	case 2:	p[0] = 0; p[1] = c; p[2] = x; return;
	case 3:	p[0] = 0; p[1] = x; p[2] = c; return;
	case 4:	p[0] = x; p[1] = 0; p[2] = c; return;
	case 5:	p[0] = c; p[1] = 0; p[2] = x; return;
	}
}

int main(void)
{
	const int size = 512;
	int i, j;
	unsigned char *colors = malloc(size * 3);
	unsigned char *pix = malloc(size * size * 3), *p;
	FILE *fp;

	for (i = 0; i < size; i++)
		hue_to_rgb(i * 240. / size, i * 1. / size, colors + 3 * i);

	for (i = 0, p = pix; i < size; i++)
		for (j = 0; j < size; j++, p += 3)
			memcpy(p, colors + (i ^ j) * 3, 3);

	fp = fopen("xor.ppm", "wb");
	fprintf(fp, "P6\n%d %d\n255\n", size, size);
	fwrite(pix, size * size * 3, 1, fp);
	fclose(fp);

	return 0;
}
