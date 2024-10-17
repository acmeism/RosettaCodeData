type Point = auto class
  x,y: real;
end;

function Sign(pt1,pt2,pt3: Point)
  := (pt1.x - pt3.x) * (pt2.y - pt3.y) - (pt2.x - pt3.x) * (pt1.y - pt3.y);

function InTriangle(p,pt1,pt2,pt3: Point): boolean;
begin
  var val1 := Sign(p, pt1, pt2);
  var val2 := Sign(p, pt2, pt3);
  var val3 := Sign(p, pt3, pt1);
  var notanyneg := (val1 >= 0) and (val2 >= 0) and (val3 >= 0);
  var notanypos := (val1 <= 0) and (val2 <= 0) and (val3 <= 0);
  Result := notanyneg or notanypos;
end;

begin
  var p1 := new Point(1.5, 2.4);
  var p2 := new Point(5.1, -3.1);
  var p3 := new Point(-3.8, 0.5);
  for var x := 0 to 5 do
  begin
    var p := new Point(x,0);
    Println($'{p} is in triangle ({p1},{p2},{p3}): {InTriangle(p,p1,p2,p3)}');
  end
end.
