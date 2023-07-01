#include <cstdio>
#include <cstdlib>

// CRTP: Curiously Recurring Template Pattern
template <typename Derived>
class PointShape
{
protected:
  int x, y;
public:
  PointShape(int x0, int y0) : x(x0), y(y0) { }
  ~PointShape() { }
  int getX() { return x; }
  int getY() { return y; }
  int setX(int x0) { x = x0; }
  int setY(int y0) { y = y0; }

  // compile-time virtual function
  void print() const { reinterpret_cast<const Derived*>(this)->printType(); }
};

class Point : public PointShape<Point>
{
public:
  Point(int x0 = 0, int y0 = 0) : PointShape(x0, y0) { }
  Point(const Point& p) : PointShape(p.x, p.y) { }
  ~Point() {}
  const Point& operator=(const Point& p)
  {
    if(this != &p)
    {
      x = p.x;
      y = p.y;
    }
    return *this;
  }
  void printType() const { printf("Point\n"); }
};

class Circle : public PointShape<Circle>
{
private:
  int r;
public:
  Circle(int x0 = 0, int y0 = 0, int r0 = 0) : PointShape(x0, y0), r(r0) { }
  Circle(Point p, int r0 = 0) : PointShape(p.getX(), p.getY()), r(r0) { }
  ~Circle() {}
  const Circle& operator=(const Circle& c)
  {
    if(this != &c)
    {
      x = c.x;
      y = c.y;
      r = c.r;
    }
    return *this;
  }
  int getR() { return r; }
  void setR(int r0) { r = r0; }
  void printType() const { printf("Circle\n"); }
};

int main()
{
  PointShape<Point>* p = new Point();
  PointShape<Circle>* c = new Circle();
  p->print();
  c->print();
  delete p;
  delete c;
  return 0;
}
