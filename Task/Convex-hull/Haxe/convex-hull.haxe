typedef Point = {x:Float, y:Float};

class Main {

    // Calculate orientation for 3 points
    // 0 -> Straight line
    // 1 -> Clockwise
    // 2 -> Counterclockwise
    static function orientation(pt1:Point, pt2:Point, pt3:Point): Int
    {
      var val = ((pt2.x - pt1.x) * (pt3.y - pt1.y)) -
                ((pt2.y - pt1.y) * (pt3.x - pt1.x));
      if (val == 0)
        return 0;
      else if (val > 0)
        return 1;
      else return 2;
    }

    static function convexHull(pts:Array<Point>):Array<Point> {
      var result = new Array<Point>();

      // There must be at least 3 points
      if (pts.length < 3)
        for (i in pts) result.push(i);

      // Find the leftmost point
      var indexMinX = 0;
      for (i in 0...(pts.length - 1))
        if (pts[i].x < pts[indexMinX].x)
          indexMinX = i;

      var p = indexMinX;
      var q = 0;

      while (true) {
        // The leftmost point must be part of the hull.
        result.push(pts[p]);

        q = (p + 1) % pts.length;

        for (i in 0...(pts.length - 1))
          if (orientation(pts[p], pts[i], pts[q]) == 2) q = i;

        p = q;

        // Break from loop once we reach the first point again.
        if (p == indexMinX)
          break;
      }
      return result;
    }

    static function main() {
      var pts = new Array<Point>();
      pts.push({x: 16, y: 3});
      pts.push({x: 12, y: 17});
      pts.push({x: 0, y: 6});
      pts.push({x: -4, y: -6});
      pts.push({x: 16, y: 6});

      pts.push({x: 16, y: -7});
      pts.push({x: 16, y: -3});
      pts.push({x: 17, y: -4});
      pts.push({x: 5, y: 19});
      pts.push({x: 19, y: -8});

      pts.push({x: 3, y: 16});
      pts.push({x: 12, y: 13});
      pts.push({x: 3, y: -4});
      pts.push({x: 17, y: 5});
      pts.push({x: -3, y: 15});

      pts.push({x: -3, y: -9});
      pts.push({x: 0, y: 11});
      pts.push({x: -9, y: -3});
      pts.push({x: -4, y: -2});
      pts.push({x: 12, y: 10});

      var hull = convexHull(pts);
      Sys.print('Convex Hull: [');
      var length = hull.length;
      var i = 0;
      while (length > 0) {
        if (i > 0)
          Sys.print(', ');
        Sys.print('(${hull[i].x}, ${hull[i].y})');
        length--;
        i++;
      }
      Sys.println(']');
    }
}
