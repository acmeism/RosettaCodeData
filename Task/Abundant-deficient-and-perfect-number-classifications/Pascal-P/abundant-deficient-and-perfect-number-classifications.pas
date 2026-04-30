program abundantetc(output);
(* Abundant, deficient and perfect number classifications *)

const
  maxnumber = 20000;
var
  pds: array [1 .. maxnumber] of integer;
  i, j, acount, dcount, pcount, divsrsum: integer;
begin
  acount := 0; dcount := 0; pcount := 0;
  pds[1] := 0;
  for i := 2 to maxnumber do pds[i] := 1;
  for i := 2 to maxnumber do
  begin
    j := i + i;
    while j <= maxnumber do
    begin
      pds[j] := pds[j] + i;
      j := j + i;
    end;
  end;
  (* Classify the numbers and count each type *)
  for i := 1 to maxnumber do
  begin
    divsrsum := pds[i];
    if divsrsum > i then acount := acount + 1
    else if divsrsum < i then dcount := dcount + 1
    else pcount := pcount + 1;
  end;
  writeln('Up to', maxnumber: 6);
  writeln('Number of abundants :', acount: 6);
  writeln('Number of perfects  :', pcount: 6);
  writeln('Number of deficients:', dcount: 6);
end.
