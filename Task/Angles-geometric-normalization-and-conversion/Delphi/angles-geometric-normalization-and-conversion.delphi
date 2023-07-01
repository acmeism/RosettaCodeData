program normalization_and_conversion;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Math;

function d2d(d: double): double;
begin
  result := FMod(d, 360);
end;

function g2g(g: double): double;
begin
  result := FMod(g, 400);
end;

function m2m(m: double): double;
begin
  result := FMod(m, 6400);
end;

function r2r(r: double): double;
begin
  result := FMod(r, 2 * Pi);
end;

function d2g(d: double): double;
begin
  result := d2d(d) * 400 / 360;
end;

function d2m(d: double): double;
begin
  result := d2d(d) * 6400 / 360;
end;

function d2r(d: double): double;
begin
  result := d2d(d) * Pi / 180;
end;

function g2d(g: double): double;
begin
  result := g2g(g) * 360 / 400;
end;

function g2m(g: double): double;
begin
  result := g2g(g) * 6400 / 400;
end;

function g2r(g: double): double;
begin
  result := g2g(g) * Pi / 200;
end;

function m2d(m: double): double;
begin
  result := m2m(m) * 360 / 6400;
end;

function m2g(m: double): double;
begin
  result := m2m(m) * 400 / 6400;
end;

function m2r(m: double): double;
begin
  result := m2m(m) * Pi / 3200;
end;

function r2d(r: double): double;
begin
  result := r2r(r) * 180 / Pi;
end;

function r2g(r: double): double;
begin
  result := r2r(r) * 200 / Pi;
end;

function r2m(r: double): double;
begin
  result := r2r(r) * 3200 / Pi;
end;

function s(f: double): string;
begin
  var wf := FloatToStrF(f, ffGeneral, 16, 64).Split([FormatSettings.DecimalSeparator], TStringSplitOptions.ExcludeEmpty);
  if Length(wf) = 1 then
    exit(format('%7s        ', [wf[0]]));
  var le := length(wf[1]);
  if le > 7 then
    le := 7;
  Result := format('%7s.%-7s', [wf[0], copy(wf[1], 0, le)]);
end;

begin
  var angles: TArray<Double> := [-2, -1, 0, 1, 2, 6.2831853, 16, 57.2957795, 359,
    399, 6399, 1000000];

  var ft := '%s %s %s %s %s';

  writeln(format(ft, ['    degrees    ', 'normalized degs', '    gradians   ',
    '     mils      ', '     radians']));
  for var a in angles do
    writeln(format(ft, [s(a), s(d2d(a)), s(d2g(a)), s(d2m(a)), s(d2r(a))]));

  writeln(format(ft, [#10'   gradians    ', 'normalized grds', '    degrees    ',
    '     mils      ', '     radians']));

  for var a in angles do
    writeln(format(ft, [s(a), s(g2g(a)), s(g2d(a)), s(g2m(a)), s(g2r(a))]));

  writeln(format(ft, [#10'     mils      ', 'normalized mils', '    degrees    ',
    '   gradians    ', '     radians']));
  for var a in angles do
    writeln(format(ft, [s(a), s(m2m(a)), s(m2d(a)), s(m2g(a)), s(m2r(a))]));

  writeln(format(ft, [#10'    radians    ', 'normalized rads', '    degrees    ',
    '   gradians    ', '      mils  ']));
  for var a in angles do
    writeln(format(ft, [s(a), s(r2r(a)), s(r2d(a)), s(r2g(a)), s(r2m(a))]));
  readln;
end.
