program multifactorial(output);

var
  n, degree: integer; (* Requires 32-bit integer *)

  function multifactorial(n: integer; degree: integer): integer;
  var
    i, res: integer;
  begin
    if (n < 2) then
      multifactorial := 1
    else
    begin
      res := n;
      i := n - degree;
      while i >= 2 do
      begin
        res := res * i;
        i := i - degree;
      end;
      multifactorial := res;
    end;
  end;

begin
  for degree := 1 to 5 do
  begin
    write('Degree ', degree:1, ' =>');
    for n := 1 to 10 do
      write(' ', multifactorial(n, degree):1);
    writeln;
  end;
  (* readln; *)
end.
