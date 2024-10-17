function fmod(x, y: real): real := x - trunc(x / y) * y;

function d2d(x: real): real := fmod(x, 360);
function g2g(x: real): real := fmod(x, 400);
function m2m(x: real): real := fmod(x, 6400);
function r2r(x: real): real := fmod(x, 2 * Pi);
function d2g(x: real): real := d2d(x) * 10 / 9;
function d2m(x: real): real := d2d(x) * 160 / 9;
function d2r(x: real): real := d2d(x) * Pi / 180;
function g2d(x: real): real := g2g(x) * 9 / 10;
function g2m(x: real): real := g2g(x) * 16;
function g2r(x: real): real := g2g(x) * Pi / 200;
function m2d(x: real): real := m2m(x) * 9 / 160;
function m2g(x: real): real := m2m(x) / 16;
function m2r(x: real): real := m2m(x) * Pi / 3200;
function r2d(x: real): real := r2r(x) * 180 / Pi;
function r2g(x: real): real := r2r(x) * 200 / Pi;
function r2m(x: real): real := r2r(x) * 3200 / Pi;

begin
  var Values: array of real := (-2, -1, 0, 1, 2, 6.2831853, 16, 57.2957795, 359, 399, 6399, 1000000);
  writeln('       Degrees      Normalized       Gradians        Mils          Radians');
  writeln('———————————————————————————————————————————————————————————————————————————');
  foreach var val in Values do
    writeln(val:15:7, d2d(val):15:7, d2g(val):15:7, d2m(val):15:7, d2r(val):15:7);
  writeln;
  writeln( '      Gradians      Normalized       Degrees         Mils          Radians');
  writeln( '———————————————————————————————————————————————————————————————————————————');
  foreach var val in Values do
    writeln( val:15:7, g2g(val):15:7,  g2d(val):15:7,  g2m(val):15:7,  g2r(val):15:7);
  writeln;
  writeln( '        Mils        Normalized       Degrees       Gradians        Radians');
  writeln( '———————————————————————————————————————————————————————————————————————————');
  foreach var val in Values do
    writeln( val:15:7,  m2m(val):15:7,  m2d(val):15:7,  m2g(val):15:7, m2r(val):15:7);
  writeln;
  writeln( '       Radians      Normalized       Degrees       Gradians        Mils');
  writeln( '———————————————————————————————————————————————————————————————————————————');
  foreach var val in Values do
    writeln( val:15:7,  r2r(val):15:7,  r2d(val):15:7,  r2g(val):15:7,  r2m(val):15:7);
end.
