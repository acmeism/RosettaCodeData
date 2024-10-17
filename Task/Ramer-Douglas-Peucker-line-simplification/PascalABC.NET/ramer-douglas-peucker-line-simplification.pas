type
  Point = (real, real);

function PerpendicularDistance(pt, lineStart, lineEnd: Point): real;
begin
  var dx := lineEnd[0] - lineStart[0];
  var dy := lineEnd[1] - lineStart[1];
  var mag := sqrt(dx * dx + dy * dy);
  if mag > 0 then begin
    dx /= mag;
    dy /= mag;
  end;
  var pvx := pt[0] - linestart[0];
  var pvy := pt[1] - linestart[1];
  var pvdot := dx * pvx + dy * pvy;
  var ax := pvx - pvdot * dx;
  var ay := pvy - pvdot * dy;
  result := sqrt(ax * ax + ay * ay);
end;

function rdp(Pointlist: list<Point>; ε: real): list<Point>;
begin
  if Pointlist.Count < 2 then exit;
  var dmax := 0.0;
  var index := 0;
  var endindex := Pointlist.Count - 1;
  for var i := 1 to endindex do
  begin
    var d := PerpendicularDistance(Pointlist[i], Pointlist[0], Pointlist[endindex]);
    if d > dmax then begin
      index := i;
      dmax := d;
    end;
  end;
  var output := new list<point>;
  if dmax > ε then begin
    var firstline := Pointlist.Take(index + 1).ToList;
    var lastline := Pointlist.Skip(index).ToList;
    var recresults1 := rdp(firstline, ε);
    var recresults2 := rdp(lastline, ε);
    output.AddRange(recresults1.Take(recresults1.Count - 1));
    output.AddRange(recresults2);
  end
  else begin
    output.Clear();
    output.Add(Pointlist[0]);
    output.Add(Pointlist[pointlist.Count - 1]);
  end;
  result := output;
end;

begin
  var pointlist: List<Point> :=
    Lst((0.0, 0.0), (1.0, 0.1), (2.0, -0.1), (3.0, 5.0), (4.0, 6.0),
        (5.0, 7.0), (6.0, 8.1), (7.0, 9.0),	(8.0, 9.0), (9.0, 9.0));
  Println(rdp(pointlist, 1.0));
end.
