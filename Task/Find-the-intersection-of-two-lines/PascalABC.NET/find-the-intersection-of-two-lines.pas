type Point = auto class
  x,y: real;
end;

function Pnt(x,y: real) := new Point(x,y);

function FindIntersection(s1,e1,s2,e2: Point): Point;
begin
  var a1 := e1.Y - s1.Y;
  var b1 := s1.X - e1.X;
  var c1 := a1 * s1.X + b1 * s1.Y;

  var a2 := e2.Y - s2.Y;
  var b2 := s2.X - e2.X;
  var c2 := a2 * s2.X + b2 * s2.Y;

  var delta := a1 * b2 - a2 * b1;

  if delta = 0 then
    Result := Pnt(real.PositiveInfinity,real.PositiveInfinity)
  else
    Result := Pnt((b2 * c1 - b1 * c2) / delta, (a1 * c2 - a2 * c1) / delta)
end;

begin
  Println(FindIntersection(Pnt(4, 0), Pnt(6, 10), Pnt(0, 3), Pnt(10, 7)));
  Println(FindIntersection(Pnt(0, 0), Pnt(1, 1), Pnt(1, 2), Pnt(4, 5)));
end.
