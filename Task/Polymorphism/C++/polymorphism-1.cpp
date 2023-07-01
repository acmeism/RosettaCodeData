#include <cstdio>
#include <cstdlib>

class Point {
protected:
    int x, y;

public:
    Point(int x0 = 0, int y0 = 0) : x(x0), y(y0) {}
    Point(const Point &p) : x(p.x), y(p.y) {}
    virtual ~Point() {}
    const Point& operator=(const Point &p) {
        if (this != &p) {
            x = p.x;
            y = p.y;
        }
        return *this;
    }
    int getX() { return x; }
    int getY() { return y; }
    void setX(int x0) { x = x0; }
    void setY(int y0) { y = y0; }
    virtual void print() { printf("Point\n"); }
};

class Circle: public Point {
private:
    int r;

public:
    Circle(Point p, int r0 = 0) : Point(p), r(r0) {}
    Circle(int x0 = 0, int y0 = 0, int r0 = 0) : Point(x0, y0), r(r0) {}
    virtual ~Circle() {}
    const Circle& operator=(const Circle &c) {
        if (this != &c) {
            x = c.x;
            y = c.y;
            r = c.r;
        }
        return *this;
    }
    int getR() { return r; }
    void setR(int r0) { r = r0; }
    virtual void print() { printf("Circle\n"); }
};

int main() {
    Point *p = new Point();
    Point *c = new Circle();
    p->print();
    c->print();
    delete p;
    delete c;

    return EXIT_SUCCESS;
}
