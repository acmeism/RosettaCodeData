{Vector structs and operations - these would normally be in}
{a library, but are produced here so everything is explicit}

type T2DVector=packed record
  X,Y: double;
  end;

type T2DLine = packed record
 P1,P2: T2DVector;
 end;

type T2DTriangle = record
 P1,P2,P3: T2DVector;
 end;



function MakeVector2D(const X,Y: double): T2DVector;
begin
Result.X:=X;
Result.Y:=Y;
end;


function Make2DLine(const P1,P2: T2DVector): T2DLine; overload;
begin
Result.P1:=P1;
Result.P2:=P2;
end;



function MakeTriangle2D(P1,P2,P3: T2DVector): T2DTriangle;
begin
Result.P1:=P1; Result.P2:=P2; Result.P3:=P3;
end;


{Point-Line position constants}

const RightPos = -1;
const LeftPos = +1;
const ColinearPos = 0;

function LinePointPosition(Line: T2DLine; Point: T2DVector): integer;
{Test the position of point relative to the line}
{Returns +1 = right side, -1 = left side, 0 = on the line}
var Side: double;
begin
{ Use the determinate to find which side of the line a point is on }
Side := (Line.P2.X - Line.P1.X) * (Point.Y - Line.P1.Y) - (Point.X - Line.P1.X) * (Line.P2.Y - Line.P1.Y);
{Return +1 = right side, -1 = left side, 0 = on the line}
if Side > 0 then Result := LeftPos
else if Side < 0 then Result := RightPos
else Result := ColinearPos;
end;


function PointInTriangle2D(P: T2DVector; Tri: T2DTriangle): boolean; overload;
{Check if specified point is inside the specified Triangle}
var Side1,Side2,Side3: integer;
var L: T2DLine;
begin
{Get the side the point falls on for the first two sides of triangle}
Side1 := LinePointPosition(Make2DLine(Tri.P1,Tri.P2),P);
Side2 := LinePointPosition(Make2DLine(Tri.P2,Tri.P3),P);

{If they are on different sides, the point must be outside}
if (Side1 * Side2) = -1 then Result := False
else
	begin
	{The point is inside the first two sides, so check the third side}
	Side3 := LinePointPosition(Make2DLine(Tri.P3,Tri.P1),P);
	{Use the three}
	if (Side1 = Side3) or (Side3 = 0) then Result := True
	else if Side1 = 0 then Result := (Side2 * Side3) >= 0
	else if Side2 = 0 then Result := (Side1 * Side3) >= 0
	else Result := False;
	end;
end;

{-------------- Test routines -------------------------------------------------}


procedure DrawTriangle(Canvas: TCanvas; T: T2DTriangle);
{Draw triangles on any canvas}
begin
Canvas.Pen.Color:=clBlack;
Canvas.Pen.Mode:=pmCopy;
Canvas.Pen.Style:=psSolid;
Canvas.Pen.Width:=2;
Canvas.MoveTo(Trunc(T.P1.X),Trunc(T.P1.Y));
Canvas.LineTo(Trunc(T.P2.X),Trunc(T.P2.Y));
Canvas.LineTo(Trunc(T.P3.X),Trunc(T.P3.Y));
Canvas.LineTo(Trunc(T.P1.X),Trunc(T.P1.Y));
end;



procedure DrawPoint(Canvas: TCanvas; X,Y: integer; InTri: boolean);
{Draw a test point on a canvas and mark if "In" or "Out"}
begin
Canvas.Pen.Color:=clRed;
Canvas.Pen.Width:=8;
Canvas.MoveTo(X-1,Y);
Canvas.LineTo(X+1,Y);
Canvas.MoveTo(X,Y-1);
Canvas.LineTo(X,Y+1);
Canvas.Font.Size:=12;
Canvas.Font.Style:=[fsBold];
if InTri then Canvas.TextOut(X+5,Y,'In')
else Canvas.TextOut(X+5,Y,'Out');
end;



procedure TestPointInTriangle(Image: TImage);
{Draw triangle and display test points}
var Tri: T2DTriangle;
var P: TPoint;
begin
{Create and draw Triangle}
Tri:=MakeTriangle2D(MakeVector2D(50,50),MakeVector2D(300,80),MakeVector2D(150,250));
DrawTriangle(Image.Canvas,Tri);

{Draw six test points}
P:=Point(62,193);
DrawPoint(Image.Canvas,P.X,P.Y, PointInTriangle2D(MakeVector2D(P.X,P.Y),Tri));
P:=Point(100,100);
DrawPoint(Image.Canvas,P.X,P.Y, PointInTriangle2D(MakeVector2D(P.X,P.Y),Tri));
P:=Point(200,100);
DrawPoint(Image.Canvas,P.X,P.Y, PointInTriangle2D(MakeVector2D(P.X,P.Y),Tri));
P:=Point(150,30);
DrawPoint(Image.Canvas,P.X,P.Y, PointInTriangle2D(MakeVector2D(P.X,P.Y),Tri));
P:=Point(250,200);
DrawPoint(Image.Canvas,P.X,P.Y, PointInTriangle2D(MakeVector2D(P.X,P.Y),Tri));
P:=Point(150,200);
DrawPoint(Image.Canvas,P.X,P.Y, PointInTriangle2D(MakeVector2D(P.X,P.Y),Tri));
end;
