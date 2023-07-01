#include <iostream>
#include <cmath>
#include <cassert>
using namespace std;

#define PI 3.14159265359

class Vector
{
public:
    Vector(double ix, double iy, char mode)
    {
        if(mode=='a')
        {
            x=ix*cos(iy);
            y=ix*sin(iy);
        }
        else
        {
            x=ix;
            y=iy;
        }
    }
    Vector(double ix,double iy)
    {
        x=ix;
        y=iy;
    }
    Vector operator+(const Vector& first)
    {
        return Vector(x+first.x,y+first.y);
    }
    Vector operator-(Vector first)
    {
        return Vector(x-first.x,y-first.y);
    }
    Vector operator*(double scalar)
    {
        return Vector(x*scalar,y*scalar);
    }
    Vector operator/(double scalar)
    {
        return Vector(x/scalar,y/scalar);
    }
    bool operator==(Vector first)
    {
        return (x==first.x&&y==first.y);
    }
    void v_print()
    {
        cout << "X: " << x << " Y: " << y;
    }
    double x,y;
};

int main()
{
    Vector vec1(0,1);
    Vector vec2(2,2);
    Vector vec3(sqrt(2),45*PI/180,'a');
    vec3.v_print();
    assert(vec1+vec2==Vector(2,3));
    assert(vec1-vec2==Vector(-2,-1));
    assert(vec1*5==Vector(0,5));
    assert(vec2/2==Vector(1,1));
    return 0;
}
