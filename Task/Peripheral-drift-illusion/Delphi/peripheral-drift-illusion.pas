{The illusion works by drawing light/dark edges around
{the squares in an inconsistent pattern that confuses}
{the eye about whethe squares are raise or lowered}

{Specifies corner on which the white lines are drawn}

type TCorners = (crTopLeft = 0,crTopRght = 1,crBtmLeft = 3,crBtmRght = 2);

{Array of edge patterns}

const Edges: array [0..12-1] of array [0..12-1] of TCorners =(
	(crTopLeft, crBtmLeft, crBtmLeft, crBtmRght, crBtmRght, crTopRght, crTopRght, crTopLeft, crTopLeft, crBtmLeft, crBtmLeft, crBtmRght),
	(crTopLeft, crTopLeft, crBtmLeft, crBtmLeft, crBtmRght, crBtmRght, crTopRght, crTopRght, crTopLeft, crTopLeft, crBtmLeft, crBtmLeft),
	(crTopRght, crTopLeft, crTopLeft, crBtmLeft, crBtmLeft, crBtmRght, crBtmRght, crTopRght, crTopRght, crTopLeft, crTopLeft, crBtmLeft),
	(crTopRght, crTopRght, crTopLeft, crTopLeft, crBtmLeft, crBtmLeft, crBtmRght, crBtmRght, crTopRght, crTopRght, crTopLeft, crTopLeft),
	(crBtmRght, crTopRght, crTopRght, crTopLeft, crTopLeft, crBtmLeft, crBtmLeft, crBtmRght, crBtmRght, crTopRght, crTopRght, crTopLeft),
	(crBtmRght, crBtmRght, crTopRght, crTopRght, crTopLeft, crTopLeft, crBtmLeft, crBtmLeft, crBtmRght, crBtmRght, crTopRght, crTopRght),
	(crBtmLeft, crBtmRght, crBtmRght, crTopRght, crTopRght, crTopLeft, crTopLeft, crBtmLeft, crBtmLeft, crBtmRght, crBtmRght, crTopRght),
	(crBtmLeft, crBtmLeft, crBtmRght, crBtmRght, crTopRght, crTopRght, crTopLeft, crTopLeft, crBtmLeft, crBtmLeft, crBtmRght, crBtmRght),
	(crTopLeft, crBtmLeft, crBtmLeft, crBtmRght, crBtmRght, crTopRght, crTopRght, crTopLeft, crTopLeft, crBtmLeft, crBtmLeft, crBtmRght),
	(crTopLeft, crTopLeft, crBtmLeft, crBtmLeft, crBtmRght, crBtmRght, crTopRght, crTopRght, crTopLeft, crTopLeft, crBtmLeft, crBtmLeft),
	(crTopRght, crTopLeft, crTopLeft, crBtmLeft, crBtmLeft, crBtmRght, crBtmRght, crTopRght, crTopRght, crTopLeft, crTopLeft, crBtmLeft),
	(crTopRght, crTopRght, crTopLeft, crTopLeft, crBtmLeft, crBtmLeft, crBtmRght, crBtmRght, crTopRght, crTopRght, crTopLeft, crTopLeft));

{Base colors}

const LightOlive: TColor = $04D0D3;
const PaleBlue: TColor = $FF523E;

{Patterns of edge colors}

type TColorArray = array [0..4-1] of array [0..4-1] of TColor;

const Colors: TColorArray = (
    (clWhite, clBlack, clBlack, clWhite),
    (clWhite, clWhite, clBlack, clBlack),
    (clBlack, clWhite, clWhite, clBlack),
    (clBlack, clBlack, clWhite, clWhite));



procedure DrawEdge(Canvas: TCanvas; PX, PY, Size: integer; Colors: TColorArray; Edge: TCorners);
{Draw edges around square}
begin
Canvas.MoveTo(PX, PY);
Canvas.Pen.Color:=Colors[Integer(Edge),0];
Canvas.LineTo(PX+Size, PY);
Canvas.Pen.Color:=Colors[Integer(Edge),1];
Canvas.LineTo(PX+Size, PY+Size);
Canvas.Pen.Color:=Colors[Integer(Edge),2];
Canvas.LineTo(PX, PY+Size);
Canvas.Pen.Color:=Colors[Integer(Edge),3];
Canvas.LineTo(PX, PY);
end;


procedure DrawPeripheralDrift(Image: TImage);
{Draw Peripheral Drift illusion}
var WWidth,WHeight: integer;
var X,Y,PX,PY: integer;
var SqrSize,Border,Spacing,InSquare,CellSize: integer;
begin
{Calculate base size from window size}
WWidth:=Min(Image.Width,Image.Height);
WHeight:=WWidth;
{Calculate border, square and spacing from base size}
InSquare:=MulDiv(WWidth,780,1000);
Border:=(WWidth-InSquare) div 2;
CellSize:=InSquare div 12;

SqrSize:=MulDiv(CellSize,75,100);
Spacing:=MulDiv(CellSize,25,100);

{Draw background rectangel}
Image.Canvas.Brush.Color:=LightOlive;
Image.Canvas.Rectangle(0,0,WWidth,WHeight);

{Draw 12x12 grid of squares}
for X:= 0 to 12-1 do
	begin
	PX:= Border + X*CellSize;
	for Y:= 0 to 12-1 do
		begin
		PY:= Border + Y*CellSize;
		{Draw square}
		Image.Canvas.Brush.Color:=PaleBlue;
		Image.Canvas.Pen.Color:=PaleBlue;
		Image.Canvas.Rectangle(PX, PY, PX+SqrSize, PY+SqrSize);
		{Draw edges, which causes the illusion}
		DrawEdge(Image.Canvas, PX, PY, SqrSize, Colors, Edges[Y,X]);
		end;
	end;
Image.Invalidate;
end;

procedure ShowPeripheralDrift(Image: TImage);
begin
DrawPeripheralDrift(Image);
end;
