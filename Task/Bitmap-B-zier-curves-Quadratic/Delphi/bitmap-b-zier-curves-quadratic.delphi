{This code would normally be in a library, but is presented here for clarity}

type T2DVector=packed record
  X,Y: double;
  end;


type T2DPolygon = array of T2DVector;


function VectorSubtract2D(const V1,V2: T2DVector): T2DVector;
{Subtract V2 from V1}
begin
Result.X:= V1.X - V2.X;
Result.Y:= V1.Y - V2.Y;
end;



function ScalarProduct2D(const V: T2DVector; const S: double): T2DVector;
{Multiply vector by scalar}
begin
Result.X:=V.X * S;
Result.Y:=V.Y * S;
end;


function VectorAdd2D(const V1,V2: T2DVector): T2DVector;
{Add V1 and V2}
begin
Result.X:= V1.X + V2.X;
Result.Y:= V1.Y + V2.Y;
end;



function ScalarDivide2D(const V: T2DVector; const S: double): T2DVector;
{Divide vector by scalar}
begin
Result.X:=V.X / S;
Result.Y:=V.Y / S;
end;

{---------------- Recursive Bezier Quadratic Spline ---------------------------}

function IsZero(const A: double): Boolean;
const Epsilon = 1E-15 * 1000;
begin
Result := Abs(A) <= Epsilon;
end;


function GetEndPointTangent(EndPnt, Adj: T2DVector; tension: double): T2DVector;
{ Calculates Bezier points from cardinal spline endpoints.}
begin
{ tangent at endpoints is the line from the endpoint to the adjacent point}
Result:=VectorAdd2D(ScalarProduct2D(VectorSubtract2D(Adj, EndPnt), tension), EndPnt);
end;



procedure GetInteriorTangent(const pts: T2DPolygon; Tension: double; var P1,P2: T2DVector);
{ Calculate incoming and outgoing tangents.}
{Pts[0] = Previous point, Pts[1] = Current Point, Pts[2] = Next Point}
var Diff,TV: T2DVector;
begin
{ Tangent Vector = Next Point - Previous Point * Tension}
Diff:=VectorSubtract2D(pts[2],pts[0]);
TV:=ScalarProduct2D(Diff,Tension);

{ Add/Subtract tangent vector to get control points}
P1:=VectorSubtract2D(pts[1],TV);
P2:=VectorAdd2D(pts[1],TV);
end;


function VectorMidPoint(const P1,P2: T2DVector): T2DVector;
begin
Result:=ScalarDivide2D(VectorAdd2D(P1,P2),2);
end;


{Don't change item order}

type TBezierPoints = packed record
 BeginPoint,BeginControl,
 EndControl,EndPoint: T2DVector;
 end;


function ControlBetweenBeginEnd(BeginPoint,BeginControl,EndControl,EndPoint: double): boolean;
{ Are control points are between begin and end point}
begin
Result:=False;
if BeginControl < BeginPoint then
	begin
	if BeginControl < EndPoint then exit;
	end
else if BeginControl > EndPoint then exit;

if EndControl < BeginPoint then
	begin
	if EndControl < EndPoint then exit;
	end
else if EndControl > EndPoint then exit;
Result:=True;
end;


function RecursionDone(const Points: TBezierPoints): Boolean;
{ Function to check that recursion can be terminated}
{ Returns true if the recusion can be terminated }
const BezierPixel = 1;
var dx, dy: double;
begin
dx := Points.EndPoint.x - Points.BeginPoint.x;
dy := Points.EndPoint.y - Points.BeginPoint.y;
if Abs(dy) <= Abs(dx) then
	begin
	{ shallow line - check that control points are between begin and end}
	Result:=False;
	if not ControlBetweenBeginEnd(Points.BeginPoint.X,Points.BeginControl.X,Points.EndControl.X,Points.EndPoint.X) then exit;

	Result:=True;
	if IsZero(dx) then exit;

	if (Abs(Points.BeginControl.y - Points.BeginPoint.y - (dy / dx) * (Points.BeginControl.x - Points.BeginPoint.x)) > BezierPixel) or
	   (Abs(Points.EndControl.y -   Points.BeginPoint.y - (dy / dx) * (Points.EndControl.x -   Points.BeginPoint.x)) > BezierPixel) then
		begin
		Result := False;
		exit;
		end
	else
		begin
		Result := True;
		exit;
		end;
	end
else
	begin
	{ steep line - check that control points are between begin and end}
	Result:=False;
	if not ControlBetweenBeginEnd(Points.BeginPoint.Y,Points.BeginControl.Y,Points.EndControl.Y,Points.EndPoint.Y) then exit;
	Result:=True;
	if IsZero(dy) then exit;

	if (Abs(Points.BeginControl.x - Points.BeginPoint.x - (dx / dy) * (Points.BeginControl.y - Points.BeginPoint.y)) > BezierPixel) or
	   (Abs(Points.EndControl.x -   Points.BeginPoint.x - (dx / dy) * (Points.EndControl.y -   Points.BeginPoint.y)) > BezierPixel) then
		begin
		Result := False;
		exit;
		end
	else
		begin
		Result := True;
		exit;
		end;
	end;
end;



procedure BezierRecursion(var Points: TBezierPoints; var PtsOut: T2DPolygon; var Alloc, OutCount: Integer; level: Integer);
{Recursively subdivide the space between the two Bezier end-points}
var Points2: TBezierPoints; { for the second recursive call}
begin
{Out of memory?}
if OutCount = Alloc then
	begin
	{then double hte memory allocation}
	Alloc := Alloc * 2;
	SetLength(PtsOut, Alloc);
	end;

if (level = 0) or RecursionDone(Points) then { Recursion can be terminated}
	begin
	if OutCount = 0 then
		begin
		PtsOut[0] := Points.BeginPoint;
		OutCount := 1;
		end;
	PtsOut[OutCount] := Points.EndPoint;
	Inc(OutCount);
	end
else
	begin
	{Split Points into two halves}
	Points2.EndPoint:=Points.EndPoint;
	Points2.EndControl:=VectorMidPoint(Points.EndControl, Points.EndPoint);
	Points2.BeginPoint:=VectorMidPoint(Points.BeginControl, Points.EndControl);
	Points2.BeginControl:=VectorMidPoint(Points2.BeginPoint,Points2.EndControl);

	Points.BeginControl:=VectorMidPoint(Points.BeginPoint,  Points.BeginControl);
	Points.EndControl:=VectorMidPoint(Points.BeginControl, Points2.BeginPoint);
	Points.EndPoint:=VectorMidPoint(Points.EndControl, Points2.BeginControl);

	Points2.BeginPoint := Points.EndPoint;

	{ Do recursion on the two halves}
	BezierRecursion(Points, PtsOut, Alloc, OutCount, level - 1);
	BezierRecursion(Points2, PtsOut, Alloc, OutCount, level - 1);
	end;
end;


procedure DoQuadraticBezier(const Source: T2DPolygon; var Destination: T2DPolygon);
{Generate Bezier spline from Source polygon and store result in Destination }
{Source Format: P[0] = Start Point, P[1]= Control Point, P[2] = End Point }
var B, Alloc,OutCount: Integer;
var ptBuf: TBezierPoints;
begin
if (Length(Source) - 1) mod 3 <> 0 then exit;
OutCount := 0;
{Start with allocation of 150 to save allocation overhead}
Alloc := 150;
SetLength(Destination, Alloc);
for B:=0 to (Length(Source) - 1) div 3 - 1 do
	begin
	Move(Source[B * 3], ptBuf.BeginPoint, SizeOf(ptBuf));
	BezierRecursion(ptBuf, Destination, Alloc, OutCount, 8);
	end;
{Trim Destination to actual length}
SetLength(Destination,OutCount);
end;



procedure GetCardinalSpline(const Source: T2DPolygon; var Destination: T2DPolygon; Tension: double = 0.5);
{Generate cardinal spline from Source with result in Destination}
{Generate tangents to get the Cardinal Spline}
var i: Integer;
var pt: T2DPolygon;
var P1,P2: T2DVector;
begin
{We need at least 2 points}
if Length(Source) <= 1 then exit;

{ The points and tangents require count * 3 - 2 points.}
SetLength(pt, Length(Source) * 3 - 2);
tension := tension * 0.3;

{Calculate Tangents for each point and store results in new array}

{Do the first point}
pt[0]:=Source[0];
pt[1]:=GetEndPointTangent(Source[0], Source[1], tension);

{Do intermediates points}
for i := 0 to Length(Source) - 3 do
	begin
	GetInteriorTangent(T2DPolygon(@(Source[i])), tension, P1,P2);
	pt[3 * i + 2]:=P1;
	pt[3 * i + 3]:=Source[i + 1];
	pt[3 * i + 4]:=P2;
	end;
{Do last point}
pt[Length(Pt) - 1]:=Source[Length(Source) - 1];
pt[Length(Pt) - 2]:=GetEndPointTangent(Source[Length(Source) - 1], Source[Length(Source) - 2], Tension);

DoQuadraticBezier(pt, Destination);
end;


procedure DrawPolyline(Image: TImage; const Points: T2DPolygon);
{Draw specified polygon}
var I: Integer;
begin
if Length(Points) <2 then exit;
Image.Canvas.MoveTo(Trunc(points[0].X), Trunc(points[0].Y));
for I := 1 to Length(Points) - 1 do
	begin
	Image.Canvas.LineTo(Trunc(points[I].X), Trunc(points[I].Y));
	end;
end;


procedure DrawCurve(Image: TImage; const Points: T2DPolygon; Tension: double = 0.5);
{Draw control points and resulting spline curve }
var Pt2: T2DPolygon;
begin
if Length(Points) <= 1 then exit;
GetCardinalSpline(points, Pt2, tension);
{Draw control points}
Image.Canvas.Pen.Width:=2;
Image.Canvas.Pen.Color:=clBlue;
DrawPolyline(Image,Points);
{Draw actual spline curve}
Image.Canvas.Pen.Color:=clRed;
DrawPolyline(Image,Pt2);
end;


procedure ShowQuadBezierCurve(Image: TImage);
var Points: T2DPolygon;
begin
{Create a set of control points}
SetLength(Points,5);
Points[0].X:=50; Points[0].Y:=250;
Points[1].X:=50; Points[1].Y:=50;
Points[2].X:=250; Points[2].Y:=50;
Points[3].X:=350; Points[3].Y:=150;
Points[4].X:=400; Points[4].Y:=100;
DrawCurve(Image, Points);
Image.Invalidate;
end;
