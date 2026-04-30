program ethiopian(output);
  (* Ethiopian multiplication *)
var
  x, y, outp: integer;

  function doub(a: integer): integer;
  begin
    doub := a * 2;
  end;

  function half(a: integer): integer;
  begin
    half := a div 2;
  end;

  function iseven(a: integer): boolean;
  begin
    iseven := a mod 2 = 0;
  end;

begin
  x := 17;
  y := 34;
  write(x: 6);
  if not (iseven(x)) then
  begin
    outp := outp + y;
    writeln(' ', y: 6);
  end
  else
    writeln;
  while x >= 2 do
  begin
    x := half(x);
    y := doub(y);
    write(x: 6);
    if not (iseven(x)) then
    begin
      outp := outp + y;
      writeln(' ', y: 6);
    end
    else
      writeln;
  end;
  writeln('     = ', outp: 6);
  (* readln; *)
end.
