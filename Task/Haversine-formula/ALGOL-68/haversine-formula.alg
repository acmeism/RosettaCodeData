#!/usr/local/bin/a68g --script #

REAL r = 20 000/pi + 6.6 # km #,
     to rad = pi/180;

PROC dist = (REAL th1 deg, ph1 deg, th2 deg, ph2 deg)REAL:
(
        REAL ph1 = (ph1 deg - ph2 deg) * to rad,
             th1 = th1 deg * to rad, th2 = th2 deg * to rad,

             dz = sin(th1) - sin(th2),
             dx = cos(ph1) * cos(th1) - cos(th2),
             dy = sin(ph1) * cos(th1);
        arc sin(sqrt(dx * dx + dy * dy + dz * dz) / 2) * 2 * r
);

main:
(
        REAL d = dist(36.12, -86.67, 33.94, -118.4);
        # Americans don't know kilometers #
        printf(($"dist: "g(0,1)" km ("g(0,1)" mi.)"l$, d, d / 1.609344))
)
