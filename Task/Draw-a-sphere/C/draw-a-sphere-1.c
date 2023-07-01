#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>
#include <math.h>

const char *shades = ".:!*oe&#%@";

double light[3] = { 30, 30, -50 };
void normalize(double * v)
{
        double len = sqrt(v[0]*v[0] + v[1]*v[1] + v[2]*v[2]);
        v[0] /= len; v[1] /= len; v[2] /= len;
}

double dot(double *x, double *y)
{
        double d = x[0]*y[0] + x[1]*y[1] + x[2]*y[2];
        return d < 0 ? -d : 0;
}

void draw_sphere(double R, double k, double ambient)
{
        int i, j, intensity;
        double b;
        double vec[3], x, y;
        for (i = floor(-R); i <= ceil(R); i++) {
                x = i + .5;
                for (j = floor(-2 * R); j <= ceil(2 * R); j++) {
                        y = j / 2. + .5;
                        if (x * x + y * y <= R * R) {
                                vec[0] = x;
                                vec[1] = y;
                                vec[2] = sqrt(R * R - x * x - y * y);
                                normalize(vec);
                                b = pow(dot(light, vec), k) + ambient;
                                intensity = (1 - b) * (sizeof(shades) - 1);
                                if (intensity < 0) intensity = 0;
                                if (intensity >= sizeof(shades) - 1)
                                        intensity = sizeof(shades) - 2;
                                putchar(shades[intensity]);
                        } else
                                putchar(' ');
                }
                putchar('\n');
        }
}


int main()
{
        normalize(light);
        draw_sphere(20, 4, .1);
        draw_sphere(10, 2, .4);

        return 0;
}
