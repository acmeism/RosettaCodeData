#include <iostream>
#include <math.h>

struct PolarPoint;

// Define a point in Cartesian coordinates
struct CartesianPoint
{
    double x;
    double y;

    // Declare an implicit conversion to a polar point
    operator PolarPoint();
};

// Define a point in polar coordinates
struct PolarPoint
{
    double rho;
    double theta;

    // Declare an implicit conversion to a Cartesian point
    operator CartesianPoint();
};

// Implement the Cartesian to polar conversion
CartesianPoint::operator PolarPoint()
{
    return PolarPoint
    {
        sqrt(x*x + y*y),
        atan2(y, x)
    };
}

// Implement the polar to Cartesian conversion
PolarPoint::operator CartesianPoint()
{
    return CartesianPoint
    {
        rho * cos(theta),
        rho * sin(theta)
    };
}

int main()
{
    // Create a Cartesian point
    CartesianPoint cp1{2,-2};
    // Implicitly convert it to a polar point
    PolarPoint pp1 = cp1;
    // Implicitily convert it back to a Cartesian point
    CartesianPoint cp2 = pp1;

    std::cout << "rho=" << pp1.rho << ", theta=" << pp1.theta << "\n";
    std::cout << "x=" << cp2.x << ", y=" << cp2.y << "\n";
}
