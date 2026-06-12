#include <stdio.h>
#include <stdbool.h>

typedef struct {
    double x;
    double y;
} Vector2;

typedef struct {
    double min;
    double max;
} Projection;

typedef struct {
    double x;
    double y;
    double w;
    double h;
} Rectangle;

double dot(Vector2 v1, Vector2 v2) {
    return v1.x * v2.x + v1.y * v2.y;
}

/* In the following a polygon is represented as an array of vertices
   and a vertex by a pair of x, y coordinates in the plane. */

void getAxes(double poly[][2], size_t len, Vector2 axes[len]) {
    int i, j;
    Vector2 vector1, vector2, edge;
    for (i = 0; i < len; ++i) {
        vector1 = (Vector2){poly[i][0], poly[i][1]};
        j = (i + 1 == len) ? 0 : i + 1;
        vector2 = (Vector2){poly[j][0], poly[j][1]};
        edge = (Vector2){vector1.x - vector2.x, vector1.y - vector2.y};
        axes[i].x = -edge.y;
        axes[i].y = edge.x;
    }
}

Projection projectOntoAxis(double poly[][2], size_t len, Vector2 axis) {
    int i;
    Vector2 vector0, vector;
    double min, max, p;
    vector0 = (Vector2){poly[0][0], poly[0][1]};
    min = dot(axis, vector0);
    max = min;
    for (i = 1; i < len; ++i) {
        vector = (Vector2){poly[i][0], poly[i][1]};
        p = dot(axis, vector);
        if (p < min) {
            min = p;
        } else if (p > max) {
            max = p;
        }
    }
    return (Projection){min, max};
}

bool projectionsOverlap(Projection proj1, Projection proj2) {
    if (proj1.max < proj2.min) return false;
    if (proj2.max < proj1.min) return false;
    return true;
}

void rectToPolygon(Rectangle r, double poly[4][2]) {
    poly[0][0] = r.x;       poly[0][1] = r.y;
    poly[1][0] = r.x;       poly[1][1] = r.y + r.h;
    poly[2][0] = r.x + r.w; poly[2][1] = r.y + r.h;
    poly[3][0] = r.x + r.w; poly[3][1] = r.y;
}

bool polygonOverlapsRect(double poly1[][2], size_t len1, Rectangle rect) {
    int i;
    size_t len2 = 4;
    Vector2 axis, axes1[len1], axes2[len2];
    Projection proj1, proj2;
    /* Convert 'rect' struct into polygon form. */
    double poly2[len2][2];
    rectToPolygon(rect, poly2);
    getAxes(poly1, len1, axes1);
    getAxes(poly2, len2, axes2);
    for (i = 0; i < len1; ++i) {
        axis = axes1[i];
        proj1 = projectOntoAxis(poly1, len1, axis);
        proj2 = projectOntoAxis(poly2, len2, axis);
        if (!projectionsOverlap(proj1, proj2)) return false;
    }
    for (i = 0; i < len2; ++i) {
        axis = axes2[i];
        proj1 = projectOntoAxis(poly1, len1, axis);
        proj2 = projectOntoAxis(poly2, len2, axis);
        if (!projectionsOverlap(proj1, proj2)) return false;
    }
    return true;
}

void printPoly(double poly[][2], size_t len) {
    int i, j;
    printf("{ ");
    for (i = 0; i < len; ++i) {
        printf("{");
        for (j = 0; j < 2; ++j) {
            printf("%g", poly[i][j]);
            if (j == 0) printf(", ");
        }
        printf("}");
        if (i < len-1) printf(", ");
    }
    printf(" }\n");
}

int main() {
    double poly[][2] = { {0, 0}, {0, 2}, {1, 4}, {2, 2}, {2, 0} };
    double poly2[4][2];
    Rectangle rect1 = {4, 0, 2, 2};
    Rectangle rect2 = {1, 0, 8, 2};
    printf("poly  = ");
    printPoly(poly, 5);
    printf("rect1 = {%g, %g, %g, %g} => ", rect1.x, rect1.y, rect1.w, rect1.h);
    rectToPolygon(rect1, poly2);
    printPoly(poly2, 4);
    printf("rect2 = {%g, %g, %g, %g} => ", rect2.x, rect2.y, rect2.w, rect2.h);
    rectToPolygon(rect2, poly2);
    printPoly(poly2, 4);
    printf("\n");
    printf("poly and rect1 overlap? %s\n", polygonOverlapsRect(poly, 5, rect1) ? "true" : "false");
    printf("poly and rect2 overlap? %s\n", polygonOverlapsRect(poly, 5, rect2) ? "true" : "false");
    return 0;
}
