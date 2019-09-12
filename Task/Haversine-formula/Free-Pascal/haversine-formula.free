program HaversineDemo;
uses
  Math;

function HaversineDistance(const lat1, lon1, lat2, lon2:double):double;inline;
const
  rads = pi / 180;
  dia  = 2 * 6372.8;
begin
  HaversineDistance := dia * arcsin(sqrt(sqr(cos(rads * (lon1 - lon2)) * cos(rads * lat1)
                     - cos(rads * lat2)) + sqr(sin(rads * (lon1 - lon2))
                     * cos(rads * lat1)) + sqr(sin(rads * lat1) - sin(rads * lat2))) / 2);
end;

begin
  Writeln('Haversine distance between BNA and LAX: ', HaversineDistance(36.12, -86.67, 33.94, -118.4):7:2, ' km.');
end.
