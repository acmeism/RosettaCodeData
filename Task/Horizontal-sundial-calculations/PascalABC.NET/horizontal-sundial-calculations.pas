##
var lat := readlnreal('Enter latitude       => ');
var lng := readlnreal('Enter longitude      => ');
var med := readlnreal('Enter legal meridian => ');
println;

var slat := sin(degToRad(lat));
writeln('    sine of latitude:    ', slat:5:3);
writeln('    diff longitude:      ', lng - med:5:3);
println;
println('Hour, sun hour angle, dial hour line angle from 6am to 6pm');

for var h := -6 to 6 do
begin
  var hra := 15 * h - lng + med;
  var hla := radtodeg(arctan(slat * tan(degToRad(hra))));
  writeln('HR=', h:2, '; HRA=', hra:8:3, '; HLA=', hla:8:3);
end;
