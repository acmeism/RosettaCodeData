program leonardonumbers(output);
(* Leonardo numbers *)

type
  tstring = array [1 .. 20] of char;

  procedure writeleonardonums(l0, l1, sum, lmt: integer; what: tstring);
  (* Write the numbers *)
  var
    i: integer;
    tmp: integer;
  begin
    writeln(what, ' (', l0:1, ', ', l1:1, ', ', sum:1, '):');
    if lmt >= 1 then
      write(l0:1, ' ');
    if lmt >= 2 then
      write(l1:1, ' ');
    for i := 3 to lmt do
    begin
      write(l0 + l1 + sum:1, ' ');
      tmp := l0;
      l0 := l1;
      l1 := tmp + l1 + sum;
    end;
    writeln
  end;

begin
  writeleonardonums(1, 1, 1, 25, 'Leonardo numbers');
  writeleonardonums(0, 1, 0, 25, 'Fibonacci numbers')
end.
