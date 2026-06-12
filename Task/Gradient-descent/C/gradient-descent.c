/* Compile with gcc -O2  --std=c2x  gd.c -lm */

#include <stdio.h>
#include <tgmath.h>
#include <stdlib.h>

constexpr double  ϵ =  0x1P-24;

double f(double const x,  double const y) {
        return (x-1.)*(x-1.)*exp(-1.*y*y) + y*(y+2.)*exp(-2.*x*x);
}

double dx(double const x, double const y){
        double const p= x*(1. + ϵ);
        double const q= x*(1. - ϵ);
        return (f(p, y) - f( q, y)) / (2. * x  * ϵ);
}

double dy(double const x, double const y){
        double const p= y*(1. + ϵ);
        double const q= y*(1. - ϵ);
        return (f(x, p) - f(x, q)) / (2. * y  * ϵ);
}

int main() {
        double const lambda = 0.3;
        double x = 0.1;
        double y = -1.;
        double tempx, tempy;
        double testx, testy;
        do {
                tempx = x - lambda * dx(x,y);
                tempy = y - lambda * dy(x,y);
                testx =x;
                testy =y;
                x=tempx;
                y=tempy;
        } while (fabs(x-testx) > ϵ || fabs(y-testy)> ϵ);
        printf("x:%0.8g\ty: %0.8g\tmin: %g\n", x, y, f(x,y));
        return EXIT_SUCCESS;
}


