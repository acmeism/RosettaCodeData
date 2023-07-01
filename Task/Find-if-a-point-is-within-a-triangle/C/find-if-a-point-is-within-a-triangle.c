#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

const double EPS = 0.001;
const double EPS_SQUARE = 0.000001;

double side(double x1, double y1, double x2, double y2, double x, double y) {
    return (y2 - y1) * (x - x1) + (-x2 + x1) * (y - y1);
}

bool naivePointInTriangle(double x1, double y1, double x2, double y2, double x3, double y3, double x, double y) {
    double checkSide1 = side(x1, y1, x2, y2, x, y) >= 0;
    double checkSide2 = side(x2, y2, x3, y3, x, y) >= 0;
    double checkSide3 = side(x3, y3, x1, y1, x, y) >= 0;
    return checkSide1 && checkSide2 && checkSide3;
}

bool pointInTriangleBoundingBox(double x1, double y1, double x2, double y2, double x3, double y3, double x, double y) {
    double xMin = min(x1, min(x2, x3)) - EPS;
    double xMax = max(x1, max(x2, x3)) + EPS;
    double yMin = min(y1, min(y2, y3)) - EPS;
    double yMax = max(y1, max(y2, y3)) + EPS;
    return !(x < xMin || xMax < x || y < yMin || yMax < y);
}

double distanceSquarePointToSegment(double x1, double y1, double x2, double y2, double x, double y) {
    double p1_p2_squareLength = (x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1);
    double dotProduct = ((x - x1) * (x2 - x1) + (y - y1) * (y2 - y1)) / p1_p2_squareLength;
    if (dotProduct < 0) {
        return (x - x1) * (x - x1) + (y - y1) * (y - y1);
    } else if (dotProduct <= 1) {
        double p_p1_squareLength = (x1 - x) * (x1 - x) + (y1 - y) * (y1 - y);
        return p_p1_squareLength - dotProduct * dotProduct * p1_p2_squareLength;
    } else {
        return (x - x2) * (x - x2) + (y - y2) * (y - y2);
    }
}

bool accuratePointInTriangle(double x1, double y1, double x2, double y2, double x3, double y3, double x, double y) {
    if (!pointInTriangleBoundingBox(x1, y1, x2, y2, x3, y3, x, y)) {
        return false;
    }
    if (naivePointInTriangle(x1, y1, x2, y2, x3, y3, x, y)) {
        return true;
    }
    if (distanceSquarePointToSegment(x1, y1, x2, y2, x, y) <= EPS_SQUARE) {
        return true;
    }
    if (distanceSquarePointToSegment(x2, y2, x3, y3, x, y) <= EPS_SQUARE) {
        return true;
    }
    if (distanceSquarePointToSegment(x3, y3, x1, y1, x, y) <= EPS_SQUARE) {
        return true;
    }
    return false;
}

void printPoint(double x, double y) {
    printf("(%f, %f)", x, y);
}

void printTriangle(double x1, double y1, double x2, double y2, double x3, double y3) {
    printf("Triangle is [");
    printPoint(x1, y1);
    printf(", ");
    printPoint(x2, y2);
    printf(", ");
    printPoint(x3, y3);
    printf("] \n");
}

void test(double x1, double y1, double x2, double y2, double x3, double y3, double x, double y) {
    printTriangle(x1, y1, x2, y2, x3, y3);
    printf("Point ");
    printPoint(x, y);
    printf(" is within triangle? ");
    if (accuratePointInTriangle(x1, y1, x2, y2, x3, y3, x, y)) {
        printf("true\n");
    } else {
        printf("false\n");
    }
}

int main() {
    test(1.5, 2.4, 5.1, -3.1, -3.8, 1.2, 0, 0);
    test(1.5, 2.4, 5.1, -3.1, -3.8, 1.2, 0, 1);
    test(1.5, 2.4, 5.1, -3.1, -3.8, 1.2, 3, 1);
    printf("\n");

    test(0.1, 0.1111111111111111, 12.5, 33.333333333333336, 25, 11.11111111111111, 5.414285714285714, 14.349206349206348);
    printf("\n");

    test(0.1, 0.1111111111111111, 12.5, 33.333333333333336, -12.5, 16.666666666666668, 5.414285714285714, 14.349206349206348);
    printf("\n");

    return 0;
}
