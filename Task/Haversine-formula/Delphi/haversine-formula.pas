program HaversineDemo;
uses Math;

function HaversineDist(th1, ph1, th2, ph2:double):double;
const diameter = 2 * 6372.8;
var   dx, dy, dz:double;
begin
  ph1    := degtorad(ph1 - ph2);
  th1    := degtorad(th1);
  th2    := degtorad(th2);

  dz     := sin(th1) - sin(th2);
  dx     := cos(ph1) * cos(th1) - cos(th2);
  dy     := sin(ph1) * cos(th1);
  Result := arcsin(sqrt(sqr(dx) + sqr(dy) + sqr(dz)) / 2) * diameter;
end;

begin
  Writeln('Haversine distance: ', HaversineDist(36.12, -86.67, 33.94, -118.4):7:2, ' km.');
end.
