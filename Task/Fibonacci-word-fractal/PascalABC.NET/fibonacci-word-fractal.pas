uses Turtle;

function fibword(n: integer): string;
begin
  var a := '1'.ToString;
  result := '0';
  loop n - 2 do
  begin
    a := result + a;
    swap(a, result);
  end;
end;

procedure draw_fractal(w: string; step: real);
begin
  foreach var c in w index i do
  begin
    Forw(step);
    if c = '0' then
      if i mod 2 = 0 then TurnLeft(90)
      else TurnRight(90)
  end;
end;

begin
  var w := fibword(20);
  var step := 1;
  SetWidth(2);
  Down;
  TurnRight(90);
  draw_fractal(w, step);
end.
