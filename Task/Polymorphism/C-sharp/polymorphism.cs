using System;
class Point
{
  protected int x, y;
  public Point() : this(0) {}
  public Point(int x) : this(x,0) {}
  public Point(int x, int y) { this.x = x; this.y = y; }
  public int X { get { return x; } set { x = value; } }
  public int Y { get { return y; } set { y = value; } }
  public virtual void print() { System.Console.WriteLine("Point"); }
}

public class Circle : Point
{
  private int r;
  public Circle(Point p) : this(p,0) { }
  public Circle(Point p, int r) : base(p) { this.r = r; }
  public Circle() : this(0) { }
  public Circle(int x) : this(x,0) { }
  public Circle(int x, int y) : this(x,y,0) { }
  public Circle(int x, int y, int r) : base(x,y) { this.r = r; }
  public int R { get { return r; } set { r = value; } }
  public override void print() { System.Console.WriteLine("Circle"); }

  public static void main(String args[])
  {
    Point p = new Point();
    Point c = new Circle();
    p.print();
    c.print();
  }
}
