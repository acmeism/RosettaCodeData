{This code would normally be stored in a separate library, but they presented here for clarity}

type T2DVector=packed record
  X,Y: double;
  end;

type T2DLine = packed record
 P1,P2: T2DVector;
 end;

type T2DVectorArray = array of T2DVector;


function MakeVector2D(const X,Y: double): T2DVector;
{Create 2D Vector from X and Y}
begin
Result.X:=X;
Result.Y:=Y;
end;




procedure DoCubicSplineLine(Steps: Integer; L1,L2: T2DLine; ClearArray: boolean; var PG: T2DVectorArray);
{Do cubic Bezier spline between L1.P1 and L2.P1  }
{L1.P1 = Point1, L1.P2 = Control1, L2.P1=Control2, L2.P2 = Point2}
var P: Integer;
var V: T2DVector;
var T: double;
var A,B,C,D,E,F,G,H : double;
begin
if ClearArray then SetLength(PG,0);
A :=  L2.P2.X - (3  * L2.P1.X) + (3  * L1.P2.X) - L1.P1.X;
B := (3  * L2.P1.X) - (6  * L1.P2.X) + (3  * L1.P1.X);
C := (3  * L1.P2.X) - (3  * L1.P1.X);
D := L1.P1.X;

E := L2.P2.Y - (3  * L2.P1.Y) + (3  * L1.P2.Y) - L1.P1.Y;
F := (3  * L2.P1.Y) - (6  * L1.P2.Y) + (3  * L1.P1.Y);
G := (3  * L1.P2.Y) - (3  * L1.P1.Y);
H := L1.P1.Y;

for P:=0 to Steps-1 do
	begin
	T :=P / (Steps-1);
	V.X := (((A  * T) + B)  * T + C)  * T + D;
	V.Y := (((E  * T) + F)  * T + G)  * T + H;
	SetLength(PG,Length(PG)+1);
	PG[High(PG)]:=V;
	end;
end;

procedure MarkPoint(Image: TImage; P: TPoint);
begin
Image.Canvas.Pen.Width:=2;
Image.Canvas.Pen.Color:=clRed;
Image.Canvas.MoveTo(Trunc(P.X-3),Trunc(P.Y-3));
Image.Canvas.LineTo(Trunc(P.X+3),Trunc(P.Y+3));
Image.Canvas.MoveTo(Trunc(P.X+3),Trunc(P.Y-3));
Image.Canvas.LineTo(Trunc(P.X-3),Trunc(P.Y+3));
end;



procedure DrawControlPoint(Image: TImage; L: T2DLine);
var P1,P2: TPoint;
begin
Image.Canvas.Pen.Width:=1;
Image.Canvas.Pen.Color:=clBlue;
P1:=Point(Trunc(L.P1.X),Trunc(L.P1.Y));
P2:=Point(Trunc(L.P2.X),Trunc(L.P2.Y));

Image.Canvas.MoveTo(P1.X,P1.Y);
Image.Canvas.LineTo(P2.X,P2.Y);
Image.Canvas.Pen.Color:=clRed;
MarkPoint(Image,P2);
end;



procedure DrawOneSpline(Image: TImage; L1,L2: T2DLine);
var PG: T2DVectorArray;
var I: integer;
begin
DoCubicSplineLine(20,L1,L2,True,PG);
DrawControlPoint(Image,L1);
DrawControlPoint(Image,L2);

Image.Canvas.Pen.Width:=2;
Image.Canvas.Pen.Color:=clRed;
Image.Canvas.MoveTo(Trunc(PG[0].X),Trunc(PG[0].Y));
for I:=1 to High(PG) do
  Image.Canvas.LineTo(Trunc(PG[I].X),Trunc(PG[I].Y));
end;

procedure ShowBezierCurve(Image: TImage);
var L1,L2: T2DLine;
begin
L1.P1:=MakeVector2D(50,50);
L1.P2:=MakeVector2D(250,50);
L2.P1:=MakeVector2D(50,250);
L2.P2:=MakeVector2D(250,250);
DrawOneSpline(Image, L1,L2);
L1.P1:=MakeVector2D(250,250);
L1.P2:=MakeVector2D(450,250);
L2.P1:=MakeVector2D(250,50);
L2.P2:=MakeVector2D(450,50);
DrawOneSpline(Image, L1,L2);


Image.Invalidate;
end;
