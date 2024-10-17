{Create a 2D vector type}

type T2DVector = record
 X, Y: double;
 end;

{Test polygon}

var Polygon: array [0..4] of T2DVector =
 ((X:3; Y:4), (X:5; Y:11), (X:12; Y:8), (X:9; Y:5), (X:5; Y:6));


function GetPolygonArea(Polygon: array of T2DVector): double;
{Return the area of the polygon }
{K = [(x1y2 + x2y3 + x3y4 + ... + xny1) - (x2y1 + x3y2 + x4y3 + ... + x1yn)]/2}
var I,Inx: integer;
var P1,P2: T2DVector;
var Sum1,Sum2: double;
begin
Result:=0;
Sum1:=0; Sum2:=0;
for I:=0 to Length(Polygon)-1 do
	begin
	{Vector back to the beginning}
	if I=(Length(Polygon)-1) then Inx:=0
	else Inx:=I+1;
	P1:=Polygon[I];
	P2:=Polygon[Inx];
	Sum1:=Sum1 + P1.X * P2.Y;
	Sum2:=Sum2 + P2.X * P1.Y;
	end;
Result:=abs((Sum1 - Sum2)/2);
end;

procedure ShowPolygon(Poly: array of T2DVector; Memo: TMemo);
var I: integer;
var S: string;
begin
S:='';
for I:=0 to High(Poly) do
 S:=S+Format('(%2.1F, %2.1F) ',[Poly[I].X, Poly[I].Y]);
Memo.Lines.Add(S);
end;


procedure ShowPolygonArea(Memo: TMemo);
var Area: double;
begin
ShowPolygon(Polygon,Memo);
Area:=GetPolygonArea(Polygon);
Memo.Lines.Add('Area: '+FloatToStrF(Area,ffFixed,18,2));
end;
