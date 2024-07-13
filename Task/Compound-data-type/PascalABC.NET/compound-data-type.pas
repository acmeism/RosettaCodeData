type
  Point = class
    x,y: integer;
    constructor(x,y: integer) := (Self.x,Self.y) := (x,y);
  end;
  PointRec = record
    x,y: integer;
    constructor(x,y: integer) := (Self.x,Self.y) := (x,y);
  end;

begin
  var p := new Point(2,3);
  Println(p.x,p.y);
  var pr := new PointRec(4,5);
  Println(pr.x,pr.y);
end.
