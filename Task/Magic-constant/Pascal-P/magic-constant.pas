program magicconstant(output);
(* Magic constant *)

var
  n: integer;
  e: real;

  (* returns the magic constant of a magic square of order n + 2 *)
  function a(n: integer): integer;
  var
    n2: integer;
  begin
    n2 := n + 2;
    a := (n2 * ((n2 * n2) + 1)) div 2
  end;

  (* returns the order of the magic square whose magic constant is at least x *)
  function inva(x: real): integer;
  begin
    inva := trunc(exp(ln((2.0 * x)) / 3) + 1)
  end;

begin
  e := 1.0;
  write('The first 20 magic constants are ');
  for n := 1 to 20 do
    write(a(n): 4, ' ');
  writeln;
  writeln('The 1,000th magic constant is ', a(1000));
  for n := 1 to 20 do
  begin
    e := e * 10;
    writeln('10^', n: 2, ': ', inva(e): 9);
  end
end.
