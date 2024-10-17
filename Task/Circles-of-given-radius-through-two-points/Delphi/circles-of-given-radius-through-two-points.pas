program Circles_of_given_radius_through_two_points;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Types,
  System.Math;

const
  Cases: array[0..9] of TPointF = ((
    x: 0.1234;
    y: 0.9876
  ), (
    x: 0.8765;
    y: 0.2345
  ), (
    x: 0.0000;
    y: 2.0000
  ), (
    x: 0.0000;
    y: 0.0000
  ), (
    x: 0.1234;
    y: 0.9876
  ), (
    x: 0.1234;
    y: 0.9876
  ), (
    x: 0.1234;
    y: 0.9876
  ), (
    x: 0.8765;
    y: 0.2345
  ), (
    x: 0.1234;
    y: 0.9876
  ), (
    x: 0.1234;
    y: 0.9876
  ));
  radii: array of double = [2.0, 1.0, 2.0, 0.5, 0.0];

procedure FindCircles(p1, p2: TPointF; radius: double);
var
  separation, mirrorDistance: double;
begin
  separation := p1.Distance(p2);
  if separation = 0.0 then
  begin
    if radius = 0 then
      write(format(#10'No circles can be drawn through (%.4f,%.4f)', [p1.x, p1.y]))
    else
      write(format(#10'Infinitely many circles can be drawn through (%.4f,%.4f)',
        [p1.x, p1.y]));
    exit;
  end;

  if separation = 2 * radius then
  begin
    write(format(#10'Given points are opposite ends of a diameter of the circle with center (%.4f,%.4f) and radius %.4f',
      [(p1.x + p2.x) / 2, (p1.y + p2.y) / 2, radius]));
    exit;
  end;

  if separation > 2 * radius then
  begin
    write(format(#10'Given points are farther away from each other than a diameter of a circle with radius %.4f',
      [radius]));
    exit;
  end;

  mirrorDistance := sqrt(Power(radius, 2) - Power(separation / 2, 2));
  write(#10'Two circles are possible.');
  write(format(#10'Circle C1 with center (%.4f,%.4f), radius %.4f and Circle C2 with center (%.4f,%.4f), radius %.4f',
    [(p1.x + p2.x) / 2 + mirrorDistance * (p1.y - p2.y) / separation, (p1.y + p2.y)
    / 2 + mirrorDistance * (p2.x - p1.x) / separation, radius, (p1.x + p2.x) / 2
    - mirrorDistance * (p1.y - p2.y) / separation, (p1.y + p2.y) / 2 -
    mirrorDistance * (p2.x - p1.x) / separation, radius]));

end;

begin
  for var i := 0 to 4 do
  begin
    write(#10'Case ', i + 1,')');
    findCircles(cases[2 * i], cases[2 * i + 1], radii[i]);
  end;
  readln;
end.
