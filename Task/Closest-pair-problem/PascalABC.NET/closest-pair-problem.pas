type Point = auto class
  x,y: real;
  function Distance(p: Point): real := Sqrt((x-p.x)**2 + (y-p.y)**2);
end;

function Pnt(x,y: real) := new Point(x,y);

function RandomPoint: Point := Pnt(RandomReal(0,10),RandomReal(0,10));

function ClosestPair(points: array of Point): (Point,Point);
begin
  var pairs := points.Combinations(2);
  var pair := pairs.MinBy(pair -> pair[0].Distance(pair[1]));
  Result := (pair[0],pair[1]);
end;

begin
  var points := ArrGen(10,i -> RandomPoint);
  points.Println;

  var ClPair := ClosestPair(points);

  Println(ClPair,ClPair[0].Distance(ClPair[1]));
end.
