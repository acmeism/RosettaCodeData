uses Turtle;

procedure Hilbert(level: integer; angle,step: real);
begin
  if level = 0 then
    exit;
  TurnRight(angle);
  Hilbert(level-1, -angle, step);

  Forw(step);
  TurnLeft(angle);
  Hilbert(level-1, angle, step);

  Forw(step);
  Hilbert(level-1, angle, step);

  TurnLeft(angle);
  Forw(step);
  Hilbert(level-1, -angle, step);
  TurnRight(angle);
end;

begin
  SetWidth(2);
  ToPoint(-9,-9);
  Down;
  Hilbert(6,90,0.3);
end.
