function PasmaPixel(X,Y,W,H: integer; Offset: double): TColor;
{Return pixel based on X,Y position and the size of the image}
{Offset controls the progression through the plasma for animation}
var A, B, C, Red, Green, Blue: double;
begin
A:=X + Y + Cos(Sin(Offset) * 2) * 100 + Sin(x / 100) * 1000;
B:=Y / H / 0.2 + Offset;
C:=X / W / 0.2;
Red:=abs(Sin(B + Offset) / 2 + C / 2 - B - C + Offset);
Green:=abs(Sin(Red + Sin(A / 1000 + Offset) + Sin(Y / 40 + Offset) + Sin((X + Y) / 100) * 3));
Blue:=abs(sin(Green + Cos(B + C + Green) + Cos(C) + Sin(X / 1000)));
Result := RGB(Round(255*Red), Round(255*Green), Round(255*Blue));
end;


procedure DisplayPlasma(Bmp: TBitmap; Width,Height: integer; Offset: double);
{Draw the plasma pattern on the bitmap progressed according to "Offset"}
var X,Y: integer;
var Scan: pRGBTripleArray;
begin
Bmp.PixelFormat:=pf24Bit;
for Y:=0 to Height-1 do
	begin
	Scan:=Bmp.ScanLine[Y];
	for X:=0 to Width-1 do
		begin
		Scan[X]:=ColorToTriple(PasmaPixel(X,Y,Width,Height,Offset));
		end;
	end;
end;
var Offset: double;


procedure ShowPlasma(Image: TImage);
{Animate 10 seconds of plasma display}
var X,Y: integer;
var I,StartTime,CurTime,StopTime: integer;
const TimeLimit = 10;
begin
{setup stop time based on real-time clock}
StartTime:=GetTickCount;
StopTime:=StartTime + (TimeLimit * 1000);
{Keep display frame until stop time is reached}
for I:=0 to high(integer) do
	begin
	{Display one frame}
	DisplayPlasma(Image.Picture.Bitmap,Image.Width,Image.Height,Offset);
	{Display count-down time}
	CurTime:=GetTickCount;
	Image.Canvas.Brush.Style:=bsClear;
	Image.Canvas.TextOut(5,5,IntToStr((CurTime-StartTime) div 1000)+' '+IntToStr(I));
	Image.Repaint;
	Application.ProcessMessages;
	if Application.Terminated then exit;
	{Exit if timed out}
	if CurTime>StopTime then break;
	Sleep(50);
	{progress animation one step}
	Offset:=Offset+0.1;
	end;
end;
