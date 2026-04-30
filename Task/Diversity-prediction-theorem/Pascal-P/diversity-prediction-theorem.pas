program diverspred(output);

  (* Diversity prediction theorem *)

var
  trueval, sum, avg, avgerr, crowderr: real;
  estims: array [0 .. 1, 0 .. 4] of real;
  i, j: integer;
begin
  estims[0, 0] := 48.0;
  estims[0, 1] := 47.0;
  estims[0, 2] := 51.0;
  estims[0, 3] := 0.0;
  estims[0, 4] := 0.0;
  estims[1, 0] := 48.0;
  estims[1, 1] := 47.0;
  estims[1, 2] := 51.0;
  estims[1, 3] := 42.0;
  estims[1, 4] := 0.0;
  trueval := 49.0;
  for i := 0 to 1 do
  begin
    sum := 0.0;
    j := 0;
    while estims[i, j] <> 0 do
    begin
      sum := sum + sqr(estims[i, j] - trueval);
      j := j + 1;
    end;
    avgerr := sum / j;
    writeln('Average error : ', avgerr: 10);
    sum := 0;
    j := 0;
    while estims[i, j] <> 0 do
    begin
      sum := sum + estims[i, j];
      j := j + 1;
    end;
    avg := sum / j;
    crowderr := sqr(trueval - avg);
    writeln('Crowd error   : ', crowderr: 10);
    writeln('Diversity     : ', avgerr - crowderr: 10);
    writeln;
  end;
  (* readln; *)
end.
