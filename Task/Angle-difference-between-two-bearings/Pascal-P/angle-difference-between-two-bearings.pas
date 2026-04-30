program anglebearings(output);
  (* Angle difference between two bearings *)

  function rmod(x1, x2: real): real;
  begin
    rmod := x1 - trunc(x1 / x2) * x2;
  end;

  function getdiff(b1, b2: real): real;
  var
    r: real;
  begin
    r := rmod((b2 - b1), 360.0);
    if r >= 180.0 then
      r := r - 360.0;
    if r < -180.0 then
      r := r + 360.0;
    getdiff := r;
  end;

  procedure writerow(b1, b2: real);
  begin
    writeln(b1: 14, '    ', b2: 14, '    ', getdiff(b1, b2):14);
  end;

begin
  writeln('Input in -180 to +180 range');
  writeln('     Bearing 1         Bearing 2        Difference');
  writerow(20.0, 45.0);
  writerow(-45.0, 45.0);
  writerow(-85.0, 90.0);
  writerow(-95.0, 90.0);
  writerow(-45.0, 125.0);
  writerow(-45.0, 145.0);
  writerow(-45.0, 125.0);
  writerow(-45.0, 145.0);
  writerow(29.4803, -88.6381);
  writerow(-78.3251, -159.036);
  writeln;
  writeln('Input in wider range');
  writeln('     Bearing 1         Bearing 2        Difference');
  writerow(-70099.74233810938, 29840.67437876723);
  writerow(-165313.6666297357, 33693.9894517456);
  writerow(1174.8380510598456, -154146.66490124757);
  writerow(60175.77306795546, 42213.07192354373)
end.
