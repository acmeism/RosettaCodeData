program dotproduct(output);
  (* Dot product *)

const
  maxi = 2;

type
  realarray = array [0 .. maxi] of real;

var
  x, y: realarray;

  function dotproduct(a, b: realarray): real;
  var
    i: integer;
    res: real;
  begin
    res := 0;
    for i := 0 to maxi do
      res := res + (a[i] * b[i]);
    dotproduct := res;
  end;

begin
  x[0] := 1; x[1] := 3; x[2] := -5;
  y[0] := 4; y[1] := -2; y[2] := -1;
  writeln(dotproduct(x, y));
  (* readln; *)
end.
