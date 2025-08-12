program moebius(output);
  (* Moebius function *)

var
  t, u: integer;

  function moebius(n: integer): integer;
  var
    m, f: integer;
  begin
    m := 1;
    if n <> 1 then
    begin
      f := 2;
      repeat
        if n mod (f * f) = 0 then
          m := 0
        else
        begin
          if n mod f = 0 then
          begin
            m := -m;
            n := n div f
          end;
          f := f + 1
        end
      until (f > n) or (m = 0)
    end;
    moebius := m
  end;

begin
  for t := 0 to 9 do
  begin
    for u := 1 to 10 do
      write(moebius(10 * t + u): 2, '  ');
    writeln
  end
end.
