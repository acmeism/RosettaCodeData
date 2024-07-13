function Min<T>(a: array of T): T; where T: IComparable<T>;
begin
  Result := a[0];
  for var i:=1 to a.Length - 1 do
    if a[i].CompareTo(Result) < 0 then
      Result := a[i];
end;

type Point = record(IComparable<Point>)
  x,y: integer;
  constructor (xx,yy: integer) := (x,y) := (xx,yy);
  function CompareTo(p: Point): integer;
  begin
    Result := x.CompareTo(p.x);
    if Result = 0 then
      Result := y.CompareTo(p.y);
  end;
end;

begin
  var a := Arr(new Point(2,3),new Point(1,4), new Point(3,1));
  Print(Min(a));
end.
