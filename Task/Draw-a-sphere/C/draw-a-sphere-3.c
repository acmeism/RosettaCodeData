#include <stdio.h>
#include <stdlib.h>
#include <math.h>

#define MAXD 8
int g[] = { -1, 1, -1, 1 };
/* Perlin-like noise */
inline void
hashed(int *data, int *out, int len) {
#	define ror(a, d) ((a << (d)) | (a >> (32 - d)))
	register unsigned int h = 0x12345678, tmp;
	unsigned int *d = (void*)data;
	int i = len;

	while (i--) {
		tmp = *d++;
		h += ror(h, 15) ^ ror(tmp, 5);
	}

	h ^= ror(h, 7);
	h += ror(h, 23);
	h ^= ror(h, 19);
	h += ror(h, 11);
	h ^= ror(h, 13);
	h += ror(h, 17);
#	undef ror
	for (i = len; i--; ) {
		out[i] = g[h & 3];
		h >>= 2;
	}
}

double scale[MAXD], scale_u[MAXD];
void noise_init()
{
	int i;
	for (i = 1; i < MAXD; i++) {
		scale[i] = 1 / (1 + sqrt(i + 1));
		scale_u[i] = scale[i] / sqrt(i + 1);
	}
}

double noise(double *x, int d)
{
#	define sum(s, x) for (s = 0, j = 0; j < d; j++) s += x
	register int i, j;
	int n[MAXD], o[MAXD], g[MAXD], tmp;
	double s, r, t, w, ret, u[MAXD];

	sum(s, x[j]);
	s *= scale[d];

	for (i = 0; i < d; i++) {
		o[i] = i;
		t = x[i] + s;
		u[i] = t - (n[i] = floor(t));
	}
	o[d] = 0;

	for (i = 0; i < d - 1; i++)
		for (j = i; j < d; j++)
			if (u[o[i]] < u[o[j]])
				tmp = o[i], o[i] = o[j], o[j] = tmp;

	ret = w = 0, r = 1;
	for (s = 0, j = 0; j < d; j++) s += n[j];
	s *= scale_u[d];

	for (i = 0; i <= d; i++) {
		for (j = 0; j < d; j++)
			u[j] = x[j] + s - n[j];

		for (t = (d + 1.) / (2 * d), j = 0; j < d; j++) {
			t -= u[j] * u[j];
			if (t <= 0) break;
		}

		if (t >= 0) {
			r = 0;
			hashed(n, g, d);
			for (j = 0; j < d; j++)
				if (g[j]) r += (g[j] == 1 ? u[j] : -u[j]);
			t *= t;
			ret += r * t * t;
		}

		if (i < d) {
			n[o[i]]++;
			s += scale_u[d];
		}
	}
	return ret * (d * d);
}

double get_noise2(double x, double y)
{
	int i, ws;
	double r = 0, v[2];

	for (i = 1, ws = 0; i <= 128; i <<= 1) {
		v[0] = x * i, v[1] = y * i;
		r += noise(v, 2);
		ws ++;
	}
	r /= ws;
	return r;
}

double get_noise3(double x, double y, double z)
{
	int i, ws;
	double r = 0, v[3], w;

	for (i = 1, ws = 0; i <= 32; i <<= 1) {
		v[0] = x * i, v[1] = y * i, v[2] = z * i;
		w = 1./sqrt(i);
		r += noise(v, 3) * w;
		ws += w;
	}
	return r / ws;
}


int main(int c, char** v)
{
	unsigned char pix[256 * 256], *p;
	int i, j;
	double x, y, z, w;
	FILE *fp;

	noise_init();

	for (p = pix, i = 0; i < 256 * 256; i++) *p++ = 0;

	for (p = pix, i = 0; i < 256; i++) {
		y = (i - 128) / 125.;
		for (j = 0; j < 256; j++, p++) {
			x = (j - 128) / 125.;
			*p = (get_noise2(i/256., j/256.) + 1) / 6 * i;

			z = 1- x*x - y*y;
			if (z < 0) continue;

			z = sqrt(z);

			w = get_noise3(x, y, z);

			w = (w + 1) / 2;
			w *= (1 + x - y + z) / 3.5;
			if (w < 0) w = 0;

			*p = w * 255;
		}
	}

	fp = fopen("out.pgm", "w+");
	fprintf(fp, "P5\n256 256\n255\n");
	fwrite(pix, 1, 256 * 256, fp);
	fclose(fp);

	return 0;
}
