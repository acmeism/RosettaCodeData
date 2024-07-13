type
  Point = class
  public
    auto property x: real;
    auto property y: real;
    constructor (x,y: real);
    begin
      Self.x := x; Self.y := y;
    end;
    procedure Print; virtual;
    begin
      PABCSystem.Print(x,y);
    end;
  end;
  Circle = class(Point)
  public
    auto property r: real;
    constructor (x,y,r: real);
    begin
      inherited Create(x,y);
      Self.r := r;
    end;
    procedure Print; override;
    begin
      inherited Print;
      PABCSystem.Print(r);
    end;
  end;

begin
  var p: Point := new Point(3,5);
  var c: Circle := new Circle(10,8,4);
  p.Print;
  Println;
  c.Print;
end.
