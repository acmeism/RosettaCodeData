/* The control points of a planar quadratic Bézier curve form a
   triangle--called the "control polygon"--that completely contains
   the curve. Furthermore, the rectangle formed by the minimum and
   maximum x and y values of the control polygon completely contain
   the polygon, and therefore also the curve.

   Thus a simple method for narrowing down where intersections might
   be is: subdivide both curves until you find "small enough" regions
   where these rectangles overlap.
*/

#include <stdio.h>
#include <stdbool.h>
#include <math.h>
#include <assert.h>

typedef struct {
    double x;
    double y;
} point;

typedef struct {
    double c0;
    double c1;
    double c2;
} quadSpline; // Non-parametric spline.

typedef struct {
    quadSpline x;
    quadSpline y;
} quadCurve;  // Planar parametric spline.

// Subdivision by de Casteljau's algorithm.
void subdivideQuadSpline(quadSpline q, double t, quadSpline *u, quadSpline *v) {
    double s = 1.0 -  t;
    double c0 = q.c0;
    double c1 = q.c1;
    double c2 = q.c2;
    u->c0 = c0;
    v->c2 = c2;
    u->c1 = s * c0 + t * c1;
    v->c1 = s * c1 + t * c2;
    u->c2 = s * u->c1 + t * v->c1;
    v->c0 = u->c2;
}

void subdivideQuadCurve(quadCurve q, double t, quadCurve *u, quadCurve *v) {
    subdivideQuadSpline(q.x, t, &u->x, &v->x);
    subdivideQuadSpline(q.y, t, &u->y, &v->y);
}

// It is assumed that xa0 <= xa1, ya0 <= ya1, xb0 <= xb1, and yb0 <= yb1.
bool rectsOverlap(double xa0, double ya0, double xa1, double ya1,
                  double xb0, double yb0, double xb1, double yb1) {
    return (xb0 <= xa1 && xa0 <= xb1 && yb0 <= ya1 && ya0 <= yb1);
}

double max3(double x, double y, double z) {
    return fmax(fmax(x, y), z);
}

double min3(double x, double y, double z) {
    return fmin(fmin(x, y), z);
}

// This accepts the point as an intersection if the boxes are small enough.
void testIntersect(quadCurve p, quadCurve q, double tol,
                   bool *exclude, bool *accept, point *intersect) {
    double pxmin = min3(p.x.c0, p.x.c1, p.x.c2);
    double pymin = min3(p.y.c0, p.y.c1, p.y.c2);
    double pxmax = max3(p.x.c0, p.x.c1, p.x.c2);
    double pymax = max3(p.y.c0, p.y.c1, p.y.c2);

    double qxmin = min3(q.x.c0, q.x.c1, q.x.c2);
    double qymin = min3(q.y.c0, q.y.c1, q.y.c2);
    double qxmax = max3(q.x.c0, q.x.c1, q.x.c2);
    double qymax = max3(q.y.c0, q.y.c1, q.y.c2);
    *exclude = true;
    *accept = false;
    if (rectsOverlap(pxmin, pymin, pxmax, pymax, qxmin, qymin, qxmax, qymax)) {
        *exclude = false;
        double xmin = fmax(pxmin, qxmin);
        double xmax = fmin(pxmax, qxmax);
        assert(xmax >= xmin);
        if (xmax - xmin <= tol) {
            double ymin = fmax(pymin, qymin);
            double ymax = fmin(pymax, qymax);
            assert(ymax >= ymin);
            if (ymax - ymin <= tol) {
                *accept = true;
                intersect->x = 0.5 * xmin + 0.5 * xmax;
                intersect->y = 0.5 * ymin + 0.5 * ymax;
            }
        }
    }
}

bool seemsToBeDuplicate(point intersects[], int icount, point xy, double spacing) {
    bool seemsToBeDup = false;
    int i = 0;
    while (!seemsToBeDup && i != icount) {
        point pt = intersects[i];
        seemsToBeDup = fabs(pt.x - xy.x) < spacing && fabs(pt.y - xy.y) < spacing;
        ++i;
    }
    return seemsToBeDup;
}

void findIntersects(quadCurve p, quadCurve q, double tol, double spacing, point intersects[]) {
    int numIntersects = 0;
    typedef struct {
        quadCurve p;
        quadCurve q;
    } workset;
    workset workload[64];
    int numWorksets = 1;
    workload[0] = (workset){p, q};
    // Quit looking after having emptied the workload.
    while (numWorksets != 0) {
        workset work = workload[numWorksets-1];
        --numWorksets;
        bool exclude, accept;
        point intersect;
        testIntersect(work.p, work.q, tol, &exclude, &accept, &intersect);
        if (accept) {
            // To avoid detecting the same intersection twice, require some
            // space between intersections.
            if (!seemsToBeDuplicate(intersects, numIntersects, intersect, spacing)) {
                intersects[numIntersects++] = intersect;
                assert(numIntersects <= 4);
            }
        } else if (!exclude) {
            quadCurve p0, p1, q0, q1;
            subdivideQuadCurve(work.p, 0.5, &p0, &p1);
            subdivideQuadCurve(work.q, 0.5, &q0, &q1);
            workload[numWorksets++] = (workset){p0, q0};
            workload[numWorksets++] = (workset){p0, q1};
            workload[numWorksets++] = (workset){p1, q0};
            workload[numWorksets++] = (workset){p1, q1};
            assert(numWorksets <= 64);
        }
    }
}

int main() {
    quadCurve p, q;
    p.x = (quadSpline){-1.0,  0.0, 1.0};
    p.y = (quadSpline){ 0.0, 10.0, 0.0};
    q.x = (quadSpline){ 2.0, -8.0, 2.0};
    q.y = (quadSpline){ 1.0,  2.0, 3.0};
    double tol = 0.0000001;
    double spacing = tol * 10.0;
    point intersects[4];
    findIntersects(p, q, tol, spacing, intersects);
    int i;
    for (i = 0; i < 4; ++i) {
        printf("(% f, %f)\n", intersects[i].x, intersects[i].y);
    }
    return 0;
}
