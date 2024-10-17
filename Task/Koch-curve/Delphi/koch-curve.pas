{===== These routines would normally be in extermal       ======}
{===== libraries, but they are presented here for clarity ======}

type T2DVector=packed record
  X,Y: double;
  end;

type T2DLine = packed record
 P1,P2: T2DVector;
 end;

procedure ClearImage(Image: TImage; Color: TColor);
var R: TRect;
begin
R:=Rect(0,0,Image.Picture.Bitmap.Width,Image.Picture.Bitmap.Height);
Image.Canvas.Brush.Color:=Color;
Image.Canvas.Brush.Style:=bsSolid;
Image.Canvas.Pen.Mode:=pmCopy;
Image.Canvas.Pen.Style:=psSolid;
Image.Canvas.Pen.Color:=Color;
Image.Canvas.Rectangle(R);
Image.Invalidate;
end;



procedure DrawLine2D(Canvas: TCanvas; L: T2DLine; C: TColor);
{Draw Line on specified canvas}
begin
Canvas.Pen.Color:=C;
Canvas.MoveTo(Trunc(L.P1.X),Trunc(L.P1.Y));
Canvas.LineTo(Trunc(L.P2.X),Trunc(L.P2.Y));
end;



function MakeVector2D(const X,Y: double): T2DVector;
{Create 2D Vector from X and Y}
begin
Result.X:=X;
Result.Y:=Y;
end;


function VectorAdd2D(const V1,V2: T2DVector): T2DVector;
{Add V1 and V2}
begin
Result.X:= V1.X + V2.X;
Result.Y:= V1.Y + V2.Y;
end;


function VectorSubtract2D(const V1,V2: T2DVector): T2DVector;
{Subtract V2 from V1}
begin
Result.X:= V1.X - V2.X;
Result.Y:= V1.Y - V2.Y;
end;


function VectorABS2D(const V: T2DVector): double;
{Find ABS of vector}
begin
Result:=Sqrt(Sqr(V.X) + Sqr(V.Y));
end;


function LineLength2D(const L: T2DLine) : double; overload;
{  Find length of a line defined by P1 and P2  }
begin
Result:=VectorABS2D(VectorSubtract2D(L.P2,L.P1));
end;



function ScalarDivide2D(const V: T2DVector; const S: double): T2DVector;
{Divide vector by scalar}
begin
Result.X:=V.X / S;
Result.Y:=V.Y / S;
end;



function ScalarProduct2D(const V: T2DVector; const S: double): T2DVector;
{Multiply vector by scalar}
begin
Result.X:=V.X * S;
Result.Y:=V.Y * S;
end;


function UnitVector2D(const V: T2DVector): T2DVector;
{Return unit vector}
var L: double;
begin
L:=VectorABS2D(V);
if L=0.0 then L:=1E-99;
Result.X:=V.X / L;
Result.Y:=V.Y / L;
end;


function GetUnitNormal2D(const V: T2DVector): T2DVector; overload;
{Returns perpendicular unit vector}
begin
Result:=UnitVector2D(MakeVector2D(-V.Y, V.X));
end;


function ExtendLine2D(const L1: T2DLine; const Len: double): T2DVector;
{ Return a point that extends line L1 by Len  }
var Len1,UX,UY : double;
begin
Len1 := LineLength2D(L1)+1E-9;
UX := (L1.P2.X - L1.P1.X)/Len1;
UY := (L1.P2.Y - L1.P1.Y)/Len1;
Result.X := L1.P2.X +(UX *Len);
Result.Y := L1.P2.Y+(UY *Len);
end;



{---------------------------------------------------------------------------}

{Array of lines to contain the snow flake}

type TLineArray = array of T2DLine;

{Screen and display parameters}

var ScreenSize: TPoint;
var SquareBox: TRect;
var BoxSize: integer;

procedure ConfigureScreen(Image: TImage);
{Setup screen parameters based Image component}
begin
ScreenSize:=Point(Image.Width, Image.Height);
if ScreenSize.X<ScreenSize.Y then BoxSize:=ScreenSize.X
else BoxSize:=ScreenSize.Y;
SquareBox:=Rect(0,0,BoxSize,BoxSize);
OffsetRect(SquareBox,(ScreenSize.X-BoxSize) div 2,(ScreenSize.Y-BoxSize) div 2);
end;


procedure DrawLines(Canvas: TCanvas; Lines: TLineArray);
{Draw all the lines in the snow flake}
var I: integer;
begin
for I:=0 to High(Lines) do
 DrawLine2D(Canvas,Lines[I],clRed);
end;


procedure BreakLine(L: T2DLine; var L1,L2,L3,L4: T2DLine);
{Break one line into the four new lines of the next iteration}
var Len,Len3,O: double;
var Delta: TPoint;
var P1,P2,P3,P4,P5,Half: T2DVector;
begin
Len:=LineLength2D(L);
Len3:=Len/3;
O:= Sqrt(sqr(Len3)-sqr(Len3/2));
P1:=L.P1;
P2:=ExtendLine2D(L,-Len3*2);
P4:=ExtendLine2D(L,-Len3);
P5:=L.P2;
Half:=ScalarDivide2D(VectorAdd2D(P4,P2),2);
P3:=GetUnitNormal2D(VectorSubtract2D(P4,P2));
P3:=ScalarProduct2D(P3,O);
P3:=VectorAdd2D(P3,Half);
L1.P1:=P1; L1.P2:=P2;
L2.P1:=P2; L2.P2:=P3;
L3.P1:=P3; L3.P2:=P4;
L4.P1:=P4; L4.P2:=P5;
end;



procedure BreakAndStoreLines(Line: T2DLine; var Lines: TLineArray);
{Break one line and store the resulting four in array}
var Len: integer;
begin
Len:=Length(Lines);
SetLength(Lines,Len+4);
BreakLine(Line, Lines[Len+0],Lines[Len+1],Lines[Len+2],Lines[Len+3]);
end;


procedure BreakArray(var Lines: TLineArray);
{Break all the lines in an array and replace them with new lines}
var I: integer;
var AT: TLineArray;
begin
AT:=Lines;
SetLength(Lines,0);
for I:=0 to High(AT) do
 BreakAndStoreLines(AT[I], Lines);
end;

procedure LineSeed(var Lines: TLineArray);
{Put single line seed in array}
var Border: integer;
begin
Border:=MulDiv(BoxSize,10,100);
SetLength(Lines,1);
Lines[0].P1:=MakeVector2D(SquareBox.Left  + Border, SquareBox.Top + Border);
Lines[0].P2:=MakeVector2D(SquareBox.Right - Border, SquareBox.Top + Border);
end;


procedure TriangleSeed(var Lines: TLineArray);
{Put triangle seed in array}
const Border = 15;
var R: TRect;
var PixelBorder: integer;
var H: double;
begin
SetLength(Lines,3);
PixelBorder:=MulDiv(BoxSize,Border,100);
R.Left:=SquareBox.Left + PixelBorder;
R.Right:=SquareBox.Right - PixelBorder;
R.Top:=SquareBox.Top + MulDiv(PixelBorder,1414,1000);
R.Bottom:=SquareBox.Bottom - PixelBorder;
OffsetRect(R,0,-MulDiv(BoxSize,15,100));

Lines[0].P1:=MakeVector2D(R.Left, R.Bottom);
Lines[0].P2:=MakeVector2D(R.Right, R.Bottom);

Lines[1].P1:=Lines[0].P2;
Lines[1].P2:=MakeVector2D((R.Right+R.Left) div 2,R.Top);

Lines[2].P1:=Lines[1].P2;
Lines[2].P2:=Lines[0].P1;
end;



procedure DoKochSnowFlake(Image: TImage);
{Construct and display various Koch snow flakes}
var Lines: TLineArray;

	procedure IterateSnowflakes;
	{Iterate through six phases of snow flakes}
	var I,J: integer;
	begin
	for I:=1 to 6 do
		begin
		ClearImage(Image,clWhite);
		Image.Canvas.Pen.Color:=clBlack;
		Image.Canvas.Rectangle(SquareBox);
		Image.Canvas.TextOut(10, 15, IntToStr(I)+' '+IntToStr(Length(Lines)));
		DrawLines(Image.Canvas,Lines);
		Image.Repaint;
		Sleep(2000);
		BreakArray(Lines);
		end;
	end;


begin
ConfigureScreen(Image);
{Iterate snow flake line}
LineSeed(Lines);
IterateSnowflakes;
{Iterate snow flake triangle}
TriangleSeed(Lines);
IterateSnowflakes;
end;
