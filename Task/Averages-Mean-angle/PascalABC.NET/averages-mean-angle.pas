##
function meanAngle(deg: array of real): real;
begin
  var c: Complex := 0;
  foreach var d in deg do
    c += CplxFromPolar(1.0, DegToRad(d));
  result := RadToDeg((c / deg.length).phase);
end;

meanAngle(Arr(350.0, 10.0)).println;
meanAngle(Arr(90.0, 180.0, 270.0, 360.0)).println;
meanAngle(Arr(10.0, 20.0, 30.0)).println
