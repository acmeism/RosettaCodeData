program taunum(output);
  (* Tau number *)
var
  i, c: integer;

  (* return the Tau (number of divisors) of n *)
  function tau(n: integer): integer;
  var
    i, t, limit: integer;
  begin
    if n < 3 then
      t := n
    else
    begin
      t := 2;
      limit := (n + 1) div 2;
      for i := 2 to limit do
        if n mod i = 0 then
          t := t + 1;
    end;
    tau := t;
  end;

begin
  writeln('First 100 Tau numbers:');
  c := 0;
  i := 1;
  while c < 100 do
  begin
    if i mod tau(i) = 0 then
    begin
      write(i: 5);
      c := c + 1;
      if c mod 10 = 0 then
        writeln;
    end;
    i := i + 1;
  end;
  (* readln; *)
end.
