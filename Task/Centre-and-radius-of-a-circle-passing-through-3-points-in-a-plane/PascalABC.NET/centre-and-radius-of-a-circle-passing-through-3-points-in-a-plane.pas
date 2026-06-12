uses graphwpf;

type
  PointR = record
    x, y: real;
  end;
  CircleR = record
    center: PointR;
    radius: real;
  end;

function FindCircle(p1, p2, p3: PointR): CircleR;
begin
  var x12 := p1.x - p2.x;
  var x13 := p1.x - p3.x;
  var y12 := p1.y - p2.y;
  var y13 := p1.y - p3.y;
  var y31 := p3.y - p1.y;
  var y21 := p2.y - p1.y;
  var x31 := p3.x - p1.x;
  var x21 := p2.x - p1.x;

  var sx13 := p1.x.Sqr - p3.x.Sqr;
  var sy13 := p1.y.Sqr - p3.y.Sqr;
  var sx21 := p2.x.Sqr - p1.x.Sqr;
  var sy21 := p2.y.Sqr - p1.y.Sqr;

  var f := (sx13 * x12 + sy13 * x12 + sx21 * x13 + sy21 * x13)
            / (2.0 * (y31 * x12 - y21 * x13));
  var g := (sx13 * y12 + sy13 * y12 + sx21 * y13 + sy21 * y13)
            / (2.0 * (x31 * y12 - x21 * y13));

  var c := -(p1.x.Sqr) - p1.y.Sqr - 2.0 * g * p1.x - 2.0 * f * p1.y;
  var h := -g;
  var k := -f;
  var r := (h.Sqr + k.Sqr - c).Sqrt;

  Result.center.x := h;
  Result.center.y := k;
  Result.radius := r;
end;

begin
  var p1: PointR := (x: 22.83; y: 2.07);
  var p2: PointR := (x: 14.39; y: 30.24);
  var p3: PointR := (x: 33.65; y: 17.31);
  var solved := FindCircle(p1, p2, p3);
  Println(solved);
  setMathematicCoords(0, 60, 0, true);
  Circle(solved.center.x, solved.center.y, solved.radius);
  Line(p1.x, p1.y, p2.x, p2.y);
  Line(p1.x, p1.y, p3.x, p3.y);
  Line(p2.x, p2.y, p3.x, p3.y);
end.
