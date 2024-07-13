type
  Vector = class
    x,y: real;
  public
    constructor (xx,yy: real) := (x,y) := (xx,yy);
    function ToString: string; override := $'({x},{y})';
  end;

function operator+(v1,v2: Vector): Vector; extensionmethod
  := new Vector(v1.x + v2.x, v1.y + v2.y);

function operator-(v1,v2: Vector): Vector; extensionmethod
  := new Vector(v1.x - v2.x, v1.y - v2.y);

function operator*(v: Vector; n: real): Vector; extensionmethod
  := new Vector(v.x * n, v.y * n);

function operator*(n: real; v: Vector): Vector; extensionmethod
  := v * n;

function operator/(v: Vector; n: real): Vector; extensionmethod
  := new Vector(v.x / n, v.y / n);

begin
  var v1 := new Vector(1,2);
  var v2 := new Vector(3,4);
  Println(v1 + v2);
  Println(v1 - v2);
  Println(v1 * 2.5, 2.5 * v1);
  Println(v1 / 2);
end.
