#include <assert.h>
#include <math.h>
#include <stdio.h>

typedef struct point_tag {
    double x;
    double y;
} point_t;

// Returns the distance from point p to the line between p1 and p2
double perpendicular_distance(point_t p, point_t p1, point_t p2) {
    double dx = p2.x - p1.x;
    double dy = p2.y - p1.y;
    double d = sqrt(dx * dx + dy * dy);
    return fabs(p.x * dy - p.y * dx + p2.x * p1.y - p2.y * p1.x)/d;
}

// Simplify an array of points using the Ramer–Douglas–Peucker algorithm.
// Returns the number of output points.
size_t douglas_peucker(const point_t* points, size_t n, double epsilon,
                       point_t* dest, size_t destlen) {
    assert(n >= 2);
    assert(epsilon >= 0);
    double max_dist = 0;
    size_t index = 0;
    for (size_t i = 1; i + 1 < n; ++i) {
        double dist = perpendicular_distance(points[i], points[0], points[n - 1]);
        if (dist > max_dist) {
            max_dist = dist;
            index = i;
        }
    }
    if (max_dist > epsilon) {
        size_t n1 = douglas_peucker(points, index + 1, epsilon, dest, destlen);
        if (destlen >= n1 - 1) {
            destlen -= n1 - 1;
            dest += n1 - 1;
        } else {
            destlen = 0;
        }
        size_t n2 = douglas_peucker(points + index, n - index, epsilon, dest, destlen);
        return n1 + n2 - 1;
    }
    if (destlen >= 2) {
        dest[0] = points[0];
        dest[1] = points[n - 1];
    }
    return 2;
}

void print_points(const point_t* points, size_t n) {
    for (size_t i = 0; i < n; ++i) {
        if (i > 0)
            printf(" ");
        printf("(%g, %g)", points[i].x, points[i].y);
    }
    printf("\n");
}

int main() {
    point_t points[] = {
        {0,0}, {1,0.1}, {2,-0.1}, {3,5}, {4,6},
        {5,7}, {6,8.1}, {7,9}, {8,9}, {9,9}
    };
    const size_t len = sizeof(points)/sizeof(points[0]);
    point_t out[len];
    size_t n = douglas_peucker(points, len, 1.0, out, len);
    print_points(out, n);
    return 0;
}
