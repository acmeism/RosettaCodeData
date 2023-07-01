#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <complex.h>

double PI;
typedef double complex cplx;

void _fft(cplx buf[], cplx out[], int n, int step)
{
	if (step < n) {
		_fft(out, buf, n, step * 2);
		_fft(out + step, buf + step, n, step * 2);

		for (int i = 0; i < n; i += 2 * step) {
			cplx t = cexp(-I * PI * i / n) * out[i + step];
			buf[i / 2]     = out[i] + t;
			buf[(i + n)/2] = out[i] - t;
		}
	}
}

void fft(cplx buf[], int n)
{
	cplx out[n];
	for (int i = 0; i < n; i++) out[i] = buf[i];
	_fft(buf, out, n, 1);
}

/* pad array length to power of two */
cplx *pad_two(double g[], int len, int *ns)
{
	int n = 1;
	if (*ns) n = *ns;
	else while (n < len) n *= 2;

	cplx *buf = calloc(sizeof(cplx), n);
	for (int i = 0; i < len; i++) buf[i] = g[i];
	*ns = n;
	return buf;
}

void deconv(double g[], int lg, double f[], int lf, double out[], int row_len) {
	int ns = 0;
	cplx *g2 = pad_two(g, lg, &ns);
	cplx *f2 = pad_two(f, lf, &ns);

	fft(g2, ns);
	fft(f2, ns);

	cplx h[ns];
	for (int i = 0; i < ns; i++) h[i] = g2[i] / f2[i];
	fft(h, ns);

	for (int i = 0; i < ns; i++) {
		if (cabs(creal(h[i])) < 1e-10)
			h[i] = 0;
	}

	for (int i = 0; i > lf - lg - row_len; i--)
		out[-i] = h[(i + ns) % ns]/32;
	free(g2);
	free(f2);
}

double* unpack2(void *m, int rows, int len, int to_len)
{
	double *buf = calloc(sizeof(double), rows * to_len);
	for (int i = 0; i < rows; i++)
		for (int j = 0; j < len; j++)
			buf[i * to_len + j] = ((double(*)[len])m)[i][j];
	return buf;
}

void pack2(double * buf, int rows, int from_len, int to_len, void *out)
{
	for (int i = 0; i < rows; i++)
		for (int j = 0; j < to_len; j++)
			((double(*)[to_len])out)[i][j] = buf[i * from_len + j] / 4;
}

void deconv2(void *g, int row_g, int col_g, void *f, int row_f, int col_f, void *out) {
	double *g2 = unpack2(g, row_g, col_g, col_g);
	double *f2 = unpack2(f, row_f, col_f, col_g);

	double ff[(row_g - row_f + 1) * col_g];
	deconv(g2, row_g * col_g, f2, row_f * col_g, ff, col_g);
	pack2(ff, row_g - row_f + 1, col_g, col_g - col_f + 1, out);

	free(g2);
	free(f2);
}

double* unpack3(void *m, int x, int y, int z, int to_y, int to_z)
{
	double *buf = calloc(sizeof(double), x * to_y * to_z);
	for (int i = 0; i < x; i++)
		for (int j = 0; j < y; j++) {
			for (int k = 0; k < z; k++)
				buf[(i * to_y + j) * to_z + k] =
					((double(*)[y][z])m)[i][j][k];
		}
	return buf;
}

void pack3(double * buf, int x, int y, int z, int to_y, int to_z, void *out)
{
	for (int i = 0; i < x; i++)
		for (int j = 0; j < to_y; j++)
			for (int k = 0; k < to_z; k++)
				((double(*)[to_y][to_z])out)[i][j][k] =
					buf[(i * y + j) * z + k] / 4;
}

void deconv3(void *g, int gx, int gy, int gz, void *f, int fx, int fy, int fz, void *out) {
	double *g2 = unpack3(g, gx, gy, gz, gy, gz);
	double *f2 = unpack3(f, fx, fy, fz, gy, gz);

	double ff[(gx - fx + 1) * gy * gz];
	deconv(g2, gx * gy * gz, f2, fx * gy * gz, ff, gy * gz);
	pack3(ff, gx - fx + 1, gy, gz, gy - fy + 1, gz - fz + 1, out);

	free(g2);
	free(f2);
}

int main()
{
	PI = atan2(1,1) * 4;
	double h[2][3][4] = {
		{{-6, -8, -5,  9}, {-7, 9, -6, -8}, { 2, -7,  9,  8}},
		{{ 7,  4,  4, -6}, { 9, 9,  4, -4}, {-3,  7, -2, -3}}
	};
	int hx = 2, hy = 3, hz = 4;
	double f[3][2][3] = {	{{-9,  5, -8}, { 3,  5,  1}},
				{{-1, -7,  2}, {-5, -6,  6}},
				{{ 8,  5,  8}, {-2, -6, -4}} };
	int fx = 3, fy = 2, fz = 3;
	double g[4][4][6] = {
		{	{ 54,  42,  53, -42,  85, -72}, { 45,-170,  94, -36,  48,  73},
			{-39,  65,-112, -16, -78, -72}, {  6, -11,  -6,  62,  49,   8} },
		{ 	{-57,  49, -23,   52, -135,  66},{-23, 127, -58,   -5, -118,  64},
			{ 87, -16,  121,  23,  -41, -12},{-19,  29,   35,-148,  -11,  45} },
		{	{-55, -147, -146, -31,  55,  60},{-88,  -45,  -28,  46, -26,-144},
			{-12, -107,  -34, 150, 249,  66},{ 11,  -15,  -34,  27, -78, -50} },
		{	{ 56,  67, 108,   4,  2,-48},{ 58,  67,  89,  32, 32, -8},
			{-42, -31,-103, -30,-23, -8},{  6,   4, -26, -10, 26, 12}
		}
	};
	int gx = 4, gy = 4, gz = 6;

	double h2[gx - fx + 1][gy - fy + 1][gz - fz + 1];
	deconv3(g, gx, gy, gz, f, fx, fy, fz, h2);
	printf("deconv3(g, f):\n");
	for (int i = 0; i < gx - fx + 1; i++) {
		for (int j = 0; j < gy - fy + 1; j++) {
			for (int k = 0; k < gz - fz + 1; k++)
				printf("%g ", h2[i][j][k]);
			printf("\n");
		}
		if (i < gx - fx) printf("\n");
	}

	double f2[gx - hx + 1][gy - hy + 1][gz - hz + 1];
	deconv3(g, gx, gy, gz, h, hx, hy, hz, f2);
	printf("\ndeconv3(g, h):\n");
	for (int i = 0; i < gx - hx + 1; i++) {
		for (int j = 0; j < gy - hy + 1; j++) {
			for (int k = 0; k < gz - hz + 1; k++)
				printf("%g ", f2[i][j][k]);
			printf("\n");
		}
		if (i < gx - hx) printf("\n");
	}
}

/* two-D case; since task doesn't require showing it, it's commented out */
/*
int main()
{
	PI = atan2(1,1) * 4;
	double h[][6] = { 	{-8, 1, -7, -2, -9, 4},
				{4, 5, -5, 2, 7, -1},
				{-6, -3, -3, -6, 9, 5} };
	int hr = 3, hc = 6;

	double f[][5] = {	{-5, 2, -2, -6, -7},
				{9, 7, -6, 5, -7},
				{1, -1, 9, 2, -7},
				{5, 9, -9, 2, -5},
				{-8, 5, -2, 8, 5} };
	int fr = 5, fc = 5;
	double g[][10] = {
			{40, -21, 53, 42, 105, 1, 87, 60, 39, -28},
			{-92, -64, 19, -167, -71, -47, 128, -109, 40, -21},
			{58, 85, -93, 37, 101, -14, 5, 37, -76, -56},
			{-90, -135, 60, -125, 68, 53, 223, 4, -36, -48},
			{78, 16, 7, -199, 156, -162, 29, 28, -103, -10},
			{-62, -89, 69, -61, 66, 193, -61, 71, -8, -30},
			{48, -6, 21, -9, -150, -22, -56, 32, 85, 25}	};
	int gr = 7, gc = 10;

	double h2[gr - fr + 1][gc - fc + 1];
	deconv2(g, gr, gc, f, fr, fc, h2);
	for (int i = 0; i < gr - fr + 1; i++) {
		for (int j = 0; j < gc - fc + 1; j++)
			printf(" %g", h2[i][j]);
		printf("\n");
	}

	double f2[gr - hr + 1][gc - hc + 1];
	deconv2(g, gr, gc, h, hr, hc, f2);
	for (int i = 0; i < gr - hr + 1; i++) {
		for (int j = 0; j < gc - hc + 1; j++)
			printf(" %g", f2[i][j]);
		printf("\n");
	}
}*/
