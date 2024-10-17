type Point = auto class
  x,y,z: real;
  static function operator-(p1,p2: Point): Point := new Point (p1.x-p2.x, p1.y-p2.y, p1.z-p2.z);
  static function operator*(p1,p2: Point): real := p1.x*p2.x + p1.y*p2.y + p1.z*p2.z;
  static function operator*(p: Point; r: real): Point := new Point (p.x*r, p.y*r, p.z*r);
end;

function IntersectionPoint(RayDir, RayPoint, PlaneNormal, PlanePoint: Point): Point
  := RayPoint - RayDir * (((RayPoint - PlanePoint) * PlaneNormal) / (RayDir * PlaneNormal));

begin
  var RayDir := new Point(0.0, -1.0, -1.0);
  var RayPoint := new Point(0.0, 0.0, 10.0);
  var PlaneNormal := new Point(0.0, 0.0, 1.0);
  var PlanePoint := new Point(0.0, 0.0, 5.0);
  Print(IntersectionPoint(RayDir, RayPoint, PlaneNormal, PlanePoint));
end.
