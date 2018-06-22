/*Code verified and output corrected by Abhishek Ghosh, 23rd September 2017*/
#include <stdio.h>
#include <stdlib.h>
#include <math.h>

const char *shades = ".:!*oe&#%@";

void vsub(double *v1, double *v2, double *s) {
	s[0] = v1[0] - v2[0];
	s[1] = v1[1] - v2[1];
	s[2] = v1[2] - v2[2];
}

double normalize(double * v) {
        double len = sqrt(v[0]*v[0] + v[1]*v[1] + v[2]*v[2]);
        v[0] /= len; v[1] /= len; v[2] /= len;
	return len;
}

double dot(double *x, double *y) {
        return x[0]*y[0] + x[1]*y[1] + x[2]*y[2];
}

double * cross(double x[3], double y[3], double s[3]) {
	s[0] = x[1] * y[2] - x[2] * y[1];
	s[1] = x[2] * y[0] - x[0] * y[2];
	s[2] = x[0] * y[1] - x[1] * y[0];
	return s;
}

double* madd(double *x, double *y, double d, double *r) {
	r[0] = x[0] + y[0] * d;
	r[1] = x[1] + y[1] * d;
	r[2] = x[2] + y[2] * d;
	return r;
}

double v000[] = { -4, -3, -2 };
double v100[] = {  4, -3, -2 };
double v010[] = { -4,  3, -2 };
double v110[] = {  4,  3, -2 };
double v001[] = { -4, -3,  2 };
double v101[] = {  4, -3,  2 };
double v011[] = { -4,  3,  2 };
double v111[] = {  4,  3,  2 };

typedef struct {
	double * v[4];
	double norm[3];
} face_t;

face_t f[] = {
	{ { v000, v010, v110, v100 }, {  0,  0, -1 } },
	{ { v001, v011, v111, v101 }, {  0,  0,  1 } },
	{ { v000, v010, v011, v001 }, { -1,  0,  0 } },
	{ { v100, v110, v111, v101 }, {  1,  0,  0 } },
	{ { v000, v100, v101, v001 }, {  0, -1,  0 } },
	{ { v010, v110, v111, v011 }, {  0,  1,  0 } },
};

int in_range(double x, double x0, double x1) {
	return (x - x0) * (x - x1) <= 0;
}

int face_hit(face_t *face, double src[3], double dir[3], double hit[3], double *d)
{
	int i;
	double dist;
	for (i = 0; i < 3; i++)
		if (face->norm[i])
			dist = (face->v[0][i] - src[i]) / dir[i];

	madd(src, dir, dist, hit);
	*d = fabs(dot(dir, face->norm) * dist);

	if (face->norm[0]) {
		return  in_range(hit[1], face->v[0][1], face->v[2][1]) &&
			in_range(hit[2], face->v[0][2], face->v[2][2]);
	}
	else if (face->norm[1]) {
		return  in_range(hit[0], face->v[0][0], face->v[2][0]) &&
			in_range(hit[2], face->v[0][2], face->v[2][2]);
	}
	else if (face->norm[2]) {
		return  in_range(hit[0], face->v[0][0], face->v[2][0]) &&
			in_range(hit[1], face->v[0][1], face->v[2][1]);
	}
	return 0;
}

int main()
{
	int i, j, k;
	double eye[3] = { 7, 7, 6 };
	double dir[3] = { -1, -1, -1 }, orig[3] = {0, 0, 0};
	double hit[3], dx[3], dy[3] = {0, 0, 1}, proj[3];
	double d, *norm, dbest, b;
	double light[3] = { 6, 8, 6 }, ldist[3], decay, strength = 10;

 	normalize(cross(eye, dy, dx));
	normalize(cross(eye, dx, dy));

	for (i = -10; i <= 17; i++) {
		for (j = -35; j < 35; j++) {
			vsub(orig, orig, proj);
			madd(madd(proj, dx, j / 6., proj), dy, i/3., proj);
			vsub(proj, eye, dir);
			dbest = 1e100;
			norm = 0;
		 	for (k = 0; k < 6; k++) {
				if (!face_hit(f + k, eye, dir, hit, &d)) continue;
				if (dbest > d) {
					dbest = d;
					norm = f[k].norm;
				}
			}

			if (!norm) {
				putchar(' ');
				continue;
			}

			vsub(light, hit, ldist);
			decay = normalize(ldist);
			b = dot(norm, ldist) / decay * strength;
			if (b < 0) b = 0;
			else if (b > 1) b = 1;
			b += .2;
			if (b > 1) b = 0;
			else b = 1 - b;
			putchar(shades[(int)(b * (sizeof(shades) - 2))]);
		}
		putchar('\n');
	}

        return 0;
}
