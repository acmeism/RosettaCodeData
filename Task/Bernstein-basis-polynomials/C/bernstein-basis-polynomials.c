#include <stdio.h>

typedef double dbl;

void tobern2(dbl a0, dbl a1, dbl a2, dbl *b0, dbl *b1, dbl *b2) {
     *b0 = a0;
     *b1 = a0 + a1 / 2;
     *b2 = a0 + a1 + a2;
}

/* uses de Casteljau’s algorithm */
dbl evalbern2(dbl b0, dbl b1, dbl b2, dbl t) {
    dbl s = 1.0 - t;
    dbl b01 = s * b0 + t * b1;
    dbl b12 = s * b1 + t * b2;
    return s * b01 + t * b12;
}

void tobern3(dbl a0, dbl a1, dbl a2, dbl a3, dbl *b0, dbl *b1, dbl *b2, dbl *b3) {
    *b0 = a0;
    *b1 = a0 + a1 / 3;
    *b2 = a0 + a1 * 2/3 + a2 / 3;
    *b3 = a0 + a1 + a2 + a3;
}

/* uses de Casteljau’s algorithm */
dbl evalbern3(dbl b0, dbl b1, dbl b2, dbl b3, dbl t) {
    dbl s = 1 - t;
    dbl b01  = s * b0  + t * b1;
    dbl b12  = s * b1  + t * b2;
    dbl b23  = s * b2  + t * b3;
    dbl b012 = s * b01 + t * b12;
    dbl b123 = s * b12 + t * b23;
    return s * b012 + t * b123;
}

void bern2to3(dbl q0, dbl q1, dbl q2, dbl *c0, dbl *c1, dbl *c2, dbl *c3) {
    *c0 = q0;
    *c1 = q0 / 3   + q1 * 2/3;
    *c2 = q1 * 2/3 + q2 / 3;
    *c3 = q2;
}

/* uses Horner's rule */
dbl evalmono2(dbl a0, dbl a1, dbl a2, dbl t) {
    return a0 + (t * (a1 + (t * a2)));
}

/* uses Horner's rule */
dbl evalmono3(dbl a0, dbl a1, dbl a2, dbl a3, dbl t) {
    return a0 + (t * (a1 + (t * (a2 + (t * a3)))));
}

int main() {
    dbl pm0 = 1, pm1 = 0, pm2 = 0, pm3 = 0, pb0, pb1, pb2, pb3, pc0, pc1, pc2, pc3;
    dbl qm0 = 1, qm1 = 2, qm2 = 3, qm3 = 0, qb0, qb1, qb2, qb3, qc0, qc1, qc2, qc3;
    dbl rm0 = 1, rm1 = 2, rm2 = 3, rm3 = 4, rb0, rb1, rb2, rb3;
    dbl x, y, m;
    const char *fmt;

    printf("Subprogram(1) examples:\n");
    tobern2(pm0, pm1, pm2, &pb0, &pb1, &pb2);
    tobern2(qm0, qm1, qm2, &qb0, &qb1, &qb2);
    fmt = "mono {%g, %g, %g} --> bern {%g, %g, %g}\n";
    printf(fmt, pm0, pm1, pm2, pb0, pb1, pb2);
    printf(fmt, qm0, qm1, qm2, qb0, qb1, qb2);

    printf("\nSubprogram(2) examples:\n");
    x = 0.25;
    y = evalbern2(pb0, pb1, pb2, x);
    m = evalmono2(pm0, pm1, pm2, x);
    printf("p(%4.2f) = %g (mono %g)\n", x, y, m);
    x = 7.5;
    y = evalbern2(pb0, pb1, pb2, x);
    m = evalmono2(pm0, pm1, pm2, x);
    printf("p(%4.2f) = %g (mono %g)\n", x, y, m);
    x = 0.25;
    y = evalbern2(qb0, qb1, qb2, x);
    m = evalmono2(qm0, qm1, qm2, x);
    printf("q(%4.2f) = %g (mono %g)\n", x, y, m);
    x = 7.5;
    y = evalbern2(qb0, qb1, qb2, x);
    m = evalmono2(qm0, qm1, qm2, x);
    printf("q(%4.2f) = %g (mono %g)\n", x, y, m);

    printf("\nSubprogram(3) examples:\n");
    tobern3(pm0, pm1, pm2, pm3, &pb0, &pb1, &pb2, &pb3);
    tobern3(qm0, qm1, qm2, qm3, &qb0, &qb1, &qb2, &qb3);
    tobern3(rm0, rm1, rm2, rm3, &rb0, &rb1, &rb2, &rb3);
    fmt = "mono {%g, %g, %g, %g} --> bern {%0.14g, %0.14g, %0.14g, %0.14g}\n";
    printf(fmt, pm0, pm1, pm2, pm3, pb0, pb1, pb2, pb3);
    printf(fmt, qm0, qm1, qm2, qm3, qb0, qb1, qb2, qb3);
    printf(fmt, rm0, rm1, rm2, rm3, rb0, rb1, rb2, rb3);

    printf("\nSubprogram(4) examples:\n");
    x = 0.25;
    y = evalbern3(pb0, pb1, pb2, pb3, x);
    m = evalmono3(pm0, pm1, pm2, pm3, x);
    printf("p(%4.2f) = %g (mono %g)\n", x, y, m);
    x = 7.5;
    y = evalbern3(pb0, pb1, pb2, pb3, x);
    m = evalmono3(pm0, pm1, pm2, pm3, x);
    printf("p(%4.2f) = %g (mono %g)\n", x, y, m);
    x = 0.25;
    y = evalbern3(qb0, qb1, qb2, qb3, x);
    m = evalmono3(qm0, qm1, qm2, qm3, x);
    printf("q(%4.2f) = %g (mono %g)\n", x, y, m);
    x = 7.5;
    y = evalbern3(qb0, qb1, qb2, qb3, x);
    m = evalmono3(qm0, qm1, qm2, qm3, x);
    printf("q(%4.2f) = %g (mono %g)\n", x, y, m);
    x = 0.25;
    y = evalbern3(rb0, rb1, rb2, rb3, x);
    m = evalmono3(rm0, rm1, rm2, rm3, x);
    printf("r(%4.2f) = %g (mono %g)\n", x, y, m);
    x = 7.5;
    y = evalbern3(rb0, rb1, rb2, rb3, x);
    m = evalmono3(rm0, rm1, rm2, rm3, x);
    printf("r(%4.2f) = %g (mono %g)\n", x, y, m);

    printf("\nSubprogram(5) examples:\n");
    tobern2(pm0, pm1, pm2, &pb0, &pb1, &pb2);
    tobern2(qm0, qm1, qm2, &qb0, &qb1, &qb2);
    bern2to3(pb0, pb1, pb2, &pc0, &pc1, &pc2, &pc3);
    bern2to3(qb0, qb1, qb2, &qc0, &qc1, &qc2, &qc3);
    fmt = "mono {%g, %g, %g} --> bern {%0.14g, %0.14g, %0.14g, %0.14g}\n";
    printf(fmt, pb0, pb1, pb2, pc0, pc1, pc2, pc3);
    printf(fmt, qb0, qb1, qb2, qc0, qc1, qc2, qc3);

    return 0;
}
