#include <math.h>
#include <stdio.h>

#define DEG 0.017453292519943295769236907684886127134  // degrees to radians
#define RE 6371000.0 // Earth radius in meters
#define DD 0.001 // integrate in this fraction of the distance already covered
#define FIN 10000000.0 // integrate only to a height of 10000km, effectively infinity

static double rho(double a) {
    // the density of air as a function of height above sea level
    return exp(-a / 8500.0);
}

static double height(double a, double z, double d) {
    // a = altitude of observer
    // z = zenith angle (in degrees)
    // d = distance along line of sight
    double aa = RE + a;
    double hh = sqrt(aa * aa + d * d - 2.0 * d * aa * cos((180 - z) * DEG));
    return hh - RE;
}

static double column_density(double a, double z) {
    // integrates density along the line of sight
    double sum = 0.0, d = 0.0;
    while (d < FIN) {
        // adaptive step size to avoid it taking forever
        double delta = DD * d;
        if (delta < DD)
            delta = DD;
        sum += rho(height(a, z, d + 0.5 * delta)) * delta;
        d += delta;
    }
    return sum;
}

static double airmass(double a, double z) {
    return column_density(a, z) / column_density(a, 0.0);
}

int main() {
    puts("Angle     0 m              13700 m");
    puts("------------------------------------");
    for (double z = 0; z <= 90; z+= 5) {
        printf("%2.0f      %11.8f      %11.8f\n",
               z, airmass(0.0, z), airmass(13700.0, z));
    }
}
