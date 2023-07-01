class Point {
   protected int x, y;
   public Point() { this(0); }
   public Point(int x) { this(x, 0); }
   public Point(int x, int y) { this.x = x; this.y = y; }
   public Point(Point p) { this(p.x, p.y); }
   public int getX() { return this.x; }
   public int getY() { return this.y; }
   public void setX(int x) { this.x = x; }
   public void setY(int y) { this.y = y; }
   public void print() { System.out.println("Point x: " + this.x + " y: " + this.y); }
}

class Circle extends Point {
   private int r;
   public Circle(Point p) { this(p, 0); }
   public Circle(Point p, int r) { super(p); this.r = r; }
   public Circle() { this(0); }
   public Circle(int x) { this(x, 0); }
   public Circle(int x, int y) { this(x, y, 0); }
   public Circle(int x, int y, int r) { super(x, y); this.r = r; }
   public Circle(Circle c) { this(c.x, c.y, c.r); }
   public int getR() { return this.r; }
   public void setR(int r) { this.r = r; }
   public void print() { System.out.println("Circle x: " + this.x + " y: " + this.y + " r: " + this.r); }
}

public class test {
  public static void main(String args[]) {
    Point p = new Point();
    Point c = new Circle();
    p.print();
    c.print();
  }
}
