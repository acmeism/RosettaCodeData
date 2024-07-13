function AddSub(x,y: real): (real,real) := (x + y, x - y);

begin
  var (a,s) := AddSub(5,3);
  Print(a,s);
end.
