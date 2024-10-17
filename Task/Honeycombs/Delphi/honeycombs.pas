{Structure containing information for one hexagon}

type THexagon = record
 Points: array [0..6-1] of TPoint;
 Center: TPoint;
 Letter: Char;
 Selected: boolean;
 end;

{Array of hexagons}

var Hexagons: array of array of THexagon;


function PointInPolygon(Point: TPoint; const Polygon: array of TPoint): Boolean;
{Test if point is in the polygon}
var Rgn: HRGN;
begin
Rgn := CreatePolygonRgn(Polygon[0], Length(Polygon), WINDING);
Result := PtInRegion(rgn, Point.X, Point.Y);
DeleteObject(rgn);
end;


function HitTest(X,Y: integer; var Col,Row: integer): boolean;
{Find hexagon that X,Y may be in}
{Return a hexagon found, Hexagon is in specified by Col, Row}
var C,R: integer;
begin
Result:=True;
for R:=0 to High(Hexagons[0]) do
 for C:=0 to High(Hexagons) do
  if PointInPolygon(Point(X,Y),Hexagons[C,R].Points) then
	begin
	Col:=C; Row:=R;
	exit;
	end;
Result:=False;
end;



procedure BuildHoneyComb(Pos: TPoint; Radius: integer);
{Build honeycombo from hexagons}
var XStep,YStep: integer;
var Off: TPoint;
var Col,Row: integer;
var Cnt: integer;

	procedure SetHexagon(var Hex: THexagon; Pos: TPoint);
	{Set the points for one hexagon}
	begin
	Hex.Center:=Pos;
	Hex.Points[0]:=Point(Pos.X-Radius,Pos.Y);
	Hex.Points[1]:=Point(Pos.X-XStep,Pos.Y-YStep);
	Hex.Points[2]:=Point(Pos.X+XStep,Pos.Y-YStep);
	Hex.Points[3]:=Point(Pos.X+Radius,Pos.Y);
	Hex.Points[4]:=Point(Pos.X+XStep,Pos.Y+YStep);
	Hex.Points[5]:=Point(Pos.X-XStep,Pos.Y+YStep);
	{Assign one char to hexagon, A..Z in order created}
	Hex.Letter:=Char(Cnt+$41);
	{Deselect hexagon}
	Hex.Selected:=False;
	Inc(Cnt);
	end;

	procedure RandomizeChars;
	{Randomize the characters}
	var X1,Y1,X2,Y2: integer;
	var C: char;
	begin
	for X1:=0 to High(Hexagons) do
	 for Y1:=0 to High(Hexagons[0]) do
		begin
		X2:=Random(Length(Hexagons));
		Y2:=Random(Length(Hexagons[0]));
		C:=Hexagons[X1,Y1].Letter;
		Hexagons[X1,Y1].Letter:=Hexagons[X2,Y2].Letter;
		Hexagons[X2,Y2].Letter:=C;
		end;
	end;


begin
Cnt:=0;
{Set number of hexagons in honey comb}
SetLength(Hexagons,5,4);
{Values to set the corners of the hexagon}
XStep:=Round(Radius / 2);
YStep:=Round(Radius * 0.866025403784438646);
for Col:=0 to High(Hexagons) do
 for Row:=0 to High(Hexagons[0]) do
 	begin
	{Calculate the position of hexagon in honeycomb}
 	Off.X:=Pos.X+(Radius+XStep) * Col;
 	Off.Y:=Pos.Y+YStep*Row*2;
	if (Col and 1)=1 then Off.Y:=Off.Y + YStep;
	{Set hexagon in honeycomb}
	SetHexagon(Hexagons[Col,Row],Off);
	end;
RandomizeChars;
end;


procedure DrawHoneyComb(Canvas: TCanvas);
{Draw polygons describing honeycomb}
var Col,Row: integer;
var Hex: THexagon;
var FS: TSize;
begin
Canvas.Pen.Width:=4;
Canvas.Font.Size:=20;
Canvas.Font.Style:=[fsBold];
Canvas.Font.Name:='Arial';
FS:=Canvas.TextExtent('M');
for Col:=0 to High(Hexagons) do
 for Row:=0 to High(Hexagons[0]) do
	begin
	Hex:=Hexagons[Col,Row];
	if Hex.Selected then Canvas.Brush.Color:=clFuchsia
	else Canvas.Brush.Color:=clYellow;
	Canvas.Polygon(Hex.Points);
	Canvas.TextOut(Hex.Center.X-FS.CX div 2,Hex.Center.Y-FS.CY div 2,Hex.Letter);
	end;
end;



procedure ShowHoneycomb(Image: TImage);
var MW: TMouseWaiter;
var MI: TMouseData;
var Row,Col: integer;
begin
MW:=TMouseWaiter.Create(TWinControl(Image));
Image.Canvas.Pen.Width:=3;
BuildHoneyComb(Point(140,90),40);
DrawHoneyComb(Image.Canvas);
Image.Canvas.Brush.Color:=clWhite;
Image.Canvas.TextOut(10,10,'Click outside honeycomb to terminate');
Image.Invalidate;
while true do
	begin
	MI:=MW.WaitForMouse;
	if HitTest(MI.X,MI.Y,Col,Row) then
		begin
		Hexagons[Col,Row].Selected:=True;
		DrawHoneyComb(Image.Canvas);
		Image.Invalidate;
		end
	else break;
	if Application.Terminated then break;
	end;
end;
