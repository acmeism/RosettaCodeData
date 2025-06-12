##
var a := new Stack<real>;
var b := new Dictionary<string, (real, real) -> real>;
b['+'] := (x, y) -> y + x;
b['-'] := (x, y) -> y - x;
b['*'] := (x, y) -> y * x;
b['/'] := (x, y) -> y / x;
b['^'] := (x, y) -> y ** x;

foreach var c in '3 4 2 * 1 5 - 2 3 ^ ^ / +'.Split do
begin
  if c in b then a.Push(b[c](a.Pop, a.Pop))
  else a.Push(c.ToReal);
  println(c, a);
end;
