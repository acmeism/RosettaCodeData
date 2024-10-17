procedure ClearBackground(Image: TImage; Color: TColor);
{Clear image with specified color}
begin
Image.Canvas.Brush.Color:=Color;
Image.Canvas.Pen.Color:=Color;
Image.Canvas.Rectangle(Image.ClientRect);
end;

{Array of colors used in display}

type TColorArray = array of TColor;

{Option controls the size of lines for each level}

type TPenMode = (pmNormal,pmIncrement,pmDecrement);

{Combined structure controls the Hilbert display}

type TCurveOptions = record
 Order: integer;
 SuperImposed: boolean;
 PenMode: TPenMode;
 ColorArray: TColorArray;
 end;


procedure DrawHillbertCurve(Canvas: TCanvas; Width,Height: integer; Options: TCurveOptions);
{ Hilbert Curve}
var X,Y,X0,Y0,H,H0,StartX,StartY: double;
var I,Inx: integer;

procedure LeftUpRight(I: integer); forward;
procedure DownRightUp(I: integer); forward;
procedure RightDownLeft(I: integer); forward;
procedure UpLeftDown(I: integer); forward;


	procedure DrawRealLine(var X,Y: double);
	begin
	Canvas.LineTo(Trunc(X),Trunc(Y));
	end;

	procedure  LeftUpRight(I: integer);
	begin
	if I>0 then
		begin
		UpLeftDown(I-1);
		X:=X-H;
		DrawRealLine(X,Y);
		LeftUpRight(I-1);
		Y:=Y-H;
		DrawRealLine(X,Y);
		LeftUpRight(I-1);
		X:=X+H;
		DrawRealLine(X,Y);
		DownRightUp(I-1);
		end;
	end;

	procedure  DownRightUp(I: integer);
	begin
	if I>0 then
		begin
		RightDownLeft(I-1);
		Y:=Y+H;
		DrawRealLine(X,Y);
		DownRightUp(I-1);
		X:=X+H;
		DrawRealLine(X,Y);
		DownRightUp(I-1);
		Y:=Y-H;
		DrawRealLine(X,Y);
		LeftUpRight(I-1);
		end;
	end;

	procedure  RightDownLeft(I: integer);
	begin
	if I>0 then
		begin
		DownRightUp(I-1);
		X:=X+H;
		DrawRealLine(X,Y);
		RightDownLeft(I-1);
		Y:=Y+H;
		DrawRealLine(X,Y);
		RightDownLeft(I-1);
		X:=X-H;
		DrawRealLine(X,Y);
		UpLeftDown(I-1);
		end;
	end;

	procedure  UpLeftDown(I: integer);
	begin
	if I>0 then
		begin
		LeftUpRight(I-1);
		Y:=Y-H;
		DrawRealLine(X,Y);
		UpLeftDown(I-1);
		X:=X-H;
		DrawRealLine(X,Y);
		UpLeftDown(I-1);
		Y:=Y+H;
		DrawRealLine(X,Y);
		RightDownLeft(I-1);
		end;
	end;

begin
if Height<Width then H0:=Height else H0:=Width;
STARTX:=Width div 2;
STARTY:=Height div 2;
H:=H0;
X0:=STARTX;
Y0:=STARTY;

for I:=1 to Options.Order do
	begin
	case Options.PenMode of
	 pmDecrement: Canvas.Pen.Width:=(Options.Order - I) + 1;
	 pmIncrement: Canvas.Pen.Width:=I;
	 end;
	Inx:=(I-1) mod Length(Options.ColorArray);
	Canvas.Pen.Color:=Options.ColorArray[Inx];
	H:=H / 2;
	X0:=X0+(H / 2);
	Y0:=Y0+(H / 2);
	X:=X0;
	Y:=Y0;
	if not Options.SuperImposed and (Options.Order<>I) then continue;
	Canvas.MoveTo(Trunc(X),Trunc(Y));

	{ Draw Curve Of Order I }
	LeftUpRight(I);
	end;
end;

procedure ShowHilbertCurve(Image: TImage);
{Setup parameter and draw Hilbert curve on canvas}
var CA: TColorArray;
var Options: TCurveOptions;
begin
ClearBackground(Image,clWhite);
Image.Canvas.Pen.Width:=1;
SetLength(CA,4);
CA[0]:=clBlack;
CA[1]:=clGray;
CA[2]:=clSilver;
CA[3]:=clGray;
Options.Order:=5;
Options.SuperImposed:=True;
Options.PenMode:=pmNormal;
Options.ColorArray:=CA;

DrawHillbertCurve(Image.Canvas,Image.Width,Image.Height,Options);
end;
