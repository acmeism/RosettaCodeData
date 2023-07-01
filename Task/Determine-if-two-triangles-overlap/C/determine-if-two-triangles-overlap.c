#include <errno.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

typedef struct {
    double x, y;
} Point;

double det2D(const Point * const p1, const Point * const p2, const Point * const p3) {
    return p1->x * (p2->y - p3->y)
        + p2->x * (p3->y - p1->y)
        + p3->x * (p1->y - p2->y);
}

void checkTriWinding(Point * p1, Point * p2, Point * p3, bool allowReversed) {
    double detTri = det2D(p1, p2, p3);
    if (detTri < 0.0) {
        if (allowReversed) {
            double t = p3->x;
            p3->x = p2->x;
            p2->x = t;

            t = p3->y;
            p3->y = p2->y;
            p2->y = t;
        } else {
            errno = 1;
        }
    }
}

bool boundaryCollideChk(const Point *p1, const Point *p2, const Point *p3, double eps) {
    return det2D(p1, p2, p3) < eps;
}

bool boundaryDoesntCollideChk(const Point *p1, const Point *p2, const Point *p3, double eps) {
    return det2D(p1, p2, p3) <= eps;
}

bool triTri2D(Point t1[], Point t2[], double eps, bool allowReversed, bool onBoundary) {
    bool(*chkEdge)(Point*, Point*, Point*, double);
    int i;

    // Triangles must be expressed anti-clockwise
    checkTriWinding(&t1[0], &t1[1], &t1[2], allowReversed);
    if (errno != 0) {
        return false;
    }
    checkTriWinding(&t2[0], &t2[1], &t2[2], allowReversed);
    if (errno != 0) {
        return false;
    }

    if (onBoundary) {
        // Points on the boundary are considered as colliding
        chkEdge = boundaryCollideChk;
    } else {
        // Points on the boundary are not considered as colliding
        chkEdge = boundaryDoesntCollideChk;
    }

    //For edge E of trangle 1,
    for (i = 0; i < 3; ++i) {
        int j = (i + 1) % 3;

        //Check all points of trangle 2 lay on the external side of the edge E. If
        //they do, the triangles do not collide.
        if (chkEdge(&t1[i], &t1[j], &t2[0], eps) &&
            chkEdge(&t1[i], &t1[j], &t2[1], eps) &&
            chkEdge(&t1[i], &t1[j], &t2[2], eps)) {
            return false;
        }
    }

    //For edge E of trangle 2,
    for (i = 0; i < 3; i++) {
        int j = (i + 1) % 3;

        //Check all points of trangle 1 lay on the external side of the edge E. If
        //they do, the triangles do not collide.
        if (chkEdge(&t2[i], &t2[j], &t1[0], eps) &&
            chkEdge(&t2[i], &t2[j], &t1[1], eps) &&
            chkEdge(&t2[i], &t2[j], &t1[2], eps))
            return false;
    }

    //The triangles collide
    return true;
}

int main() {
    {
        Point t1[] = { {0, 0}, {5, 0}, {0, 5} };
        Point t2[] = { {0, 0}, {5, 0}, {0, 6} };
        printf("%d,true\n", triTri2D(t1, t2, 0.0, false, true));
    }

    {
        Point t1[] = { {0, 0}, {0, 5}, {5, 0} };
        Point t2[] = { {0, 0}, {0, 5}, {5, 0} };
        printf("%d,true\n", triTri2D(t1, t2, 0.0, true, true));
    }

    {
        Point t1[] = { {0, 0}, {5, 0}, {0, 5} };
        Point t2[] = { {-10, 0}, {-5, 0}, {-1, 6} };
        printf("%d,false\n", triTri2D(t1, t2, 0.0, false, true));
    }

    {
        Point t1[] = { {0, 0}, {5, 0}, {2.5, 5} };
        Point t2[] = { {0, 4}, {2.5, -1}, {5, 4} };
        printf("%d,true\n", triTri2D(t1, t2, 0.0, false, true));
    }

    {
        Point t1[] = { {0, 0}, {1, 1}, {0, 2} };
        Point t2[] = { {2, 1}, {3, 0}, {3, 2} };
        printf("%d,false\n", triTri2D(t1, t2, 0.0, false, true));
    }

    {
        Point t1[] = { {0, 0}, {1, 1}, {0, 2} };
        Point t2[] = { {2, 1}, {3, -2}, {3, 4} };
        printf("%d,false\n", triTri2D(t1, t2, 0.0, false, true));
    }

    //Barely touching
    {
        Point t1[] = { {0, 0}, {1, 0}, {0, 1} };
        Point t2[] = { {1, 0}, {2, 0}, {1, 1} };
        printf("%d,true\n", triTri2D(t1, t2, 0.0, false, true));
    }

    //Barely touching
    {
        Point t1[] = { {0, 0}, {1, 0}, {0, 1} };
        Point t2[] = { {1, 0}, {2, 0}, {1, 1} };
        printf("%d,false\n", triTri2D(t1, t2, 0.0, false, false));
    }

    return EXIT_SUCCESS;
}
