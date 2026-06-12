const RE  = 6371000; { radius of earth in meters}
const DD  = 0.001;   { integrate in this fraction of the distance already covered}
const FIN = 1e7;     { integrate only to a height of 10000km, effectively infinity}

function rho(a: double): double;
{ The density of air as a function of height above sea level.}
begin
Result:=Exp(-a / 8500);
end;

function Radians(degrees: double): double;
{ Converts degrees to radians}
begin
Result:= degrees * Pi / 180
end;

function Height(A, Z, D: double): double;
{ a = altitude of observer}
{ z = zenith angle (in degrees)}
{ d = distance along line of sight}
var AA,HH: double;
begin
AA := RE + A;
HH := Sqrt(AA*AA + D*D - 2*D*AA*Cos(Radians(180-z)));
Result:= HH - RE;
end;

function ColumnDensity(A, Z: double): double;
{ Integrates density along the line of sight.}
var Sum,D,Delta: double;
begin
Sum := 0.0;
D := 0.0;
while D < FIN do
	begin
	delta := Max(DD, DD*D); { adaptive step size to avoid it taking forever}
	Sum:=Sum + Rho(Height(A, Z, D+0.5*Delta)) * Delta;
	D:=D + delta;
	end;
Result:= Sum;
end;


function AirMass(A, Z: double): double;
begin
Result:= ColumnDensity(A, Z) / ColumnDensity(a, 0);
end;

procedure ShowAirMass(Memo: TMemo);
var Z: integer;
begin
Memo.Lines.Add('Angle     0 m              13700 m');
Memo.Lines.Add('------------------------------------');
Z:=0;
while Z<=90 do
	begin
        Memo.Lines.Add(Format('%2d      %11.8f      %11.8f', [z, airmass(0, Z), airmass(13700, Z)]));
        Z:=Z+5;
        end;
end;



