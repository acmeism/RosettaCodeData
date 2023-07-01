const     N = 30000;              {number of points}
const     K = 6;                  {number of clusters}

var ScreenSize,Center: TPoint;
var Radius: integer;

var Points: array [0..N-1] of TPoint;		{coordinates of points and their cluster}
var Pc: array [0..N-1] of TColor;
var Cent: array [0..K-1] of TPoint;		{coordinates of centroid of cluster}

const Palette: array [0..5] of TColor =(
	$00 or ($00 shl 8) or ($AA shl 16),
	$00 or ($AA shl 8) or ($00 shl 16),
	$00 or ($AA shl 8) or ($AA shl 16),
	$AA or ($00 shl 8) or ($00 shl 16),
	$AA or ($00 shl 8) or ($AA shl 16),
	$AA or ($55 shl 8) or ($00 shl 16));

{These would normally be in a separate library}
{Shown here for clarity}


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


function PointAdd(V1,V2: TPoint): TPoint;
{Add V1 and V2}
begin
Result.X:= V1.X+V2.X;
Result.Y:= V1.Y+V2.Y;
end;

function PointScalarDivide(V: TPoint; S: double): TPoint;
{Divide vector by scalar}
begin
Result.X:=Trunc(V.X/S);
Result.Y:=Trunc(V.Y/S);
end;

{--------------- Main Program -------------------------------------------------}

function Centroid: boolean;
{Find new centroids of points grouped with current centroids}
var Change: boolean;
var C0: array [0..K-1] of TPoint;
var C, Count, I: integer;
begin
Change:= false;
for C:= 0 to K-1 do				{for each centroid...}
	begin
	C0[C]:= Cent[C];				{save current centroid}
	Cent[C]:=Point(0,0); Count:= 0;			{find new centroid}
	for I:= 0 to N-1 do				{for all points}
	if Pc[I] = Palette[C] then			{ grouped with current centroid...}
		begin
		Cent[C]:=PointAdd(Cent[C],Points[I]);
		Count:= Count+1;
		end;
	Cent[C]:=PointScalarDivide(Cent[C],Count);
	if (Cent[C].X<>C0[C].X) or (Cent[C].Y<>C0[C].Y) then Change:= true;
	end;
Result:=Change;
end;


procedure Voronoi;
{Group points with their nearest centroid}
var D2, MinD2, I, C: integer;           {distance squared, minimum distance squared}
begin
for I:= 0 to N-1 do            {for each point...}
        begin
        MinD2:= High(Integer);         {find closest centroid}
        for C:= 0 to K-1 do
                begin
                D2:= sqr(Points[I].X-Cent[C].X) + sqr(Points[I].Y-Cent[C].Y);
                if D2 < MinD2 then
                        begin
                        {update closest centroid}
                        MinD2:= D2;
                        Pc[I]:= Palette[C];
                        end;
                end;
        end;
end;


procedure KMeans(Image: TImage);
{Group points into K clusters}
var Change: boolean;
var I: integer;
begin
repeat
	begin
	Voronoi;
	Change:= Centroid;
        for I:= 0 to N-1 do Image.Canvas.Pixels[Points[I].X, Points[I].Y]:=Pc[I]+1;
	Image.Repaint;
        for I:= 0 to K-1 do Image.Canvas.Pixels[Cent[I].X, Cent[I].Y]:=clWhite;
	Image.Repaint;
        end
until Change = false;
end;


procedure PolarRandom(var P: TPoint);
{Return random X,Y biased for polar coordinates}
var A, D: double;
begin
D:=Random(Radius);			{distance: 0..239}
A:=Random(314159*2) / 10000;		{angle:    0..2pi}
{rectangular coords centered on screen}
P:=PointAdd(Point(Trunc(D*Cos(A)),Trunc(D*Sin(A))),Center);
end;


procedure ConfigureScreen(Image: TImage);
{Configure screem constants to match current state of Image}
begin
ScreenSize:=Point(Image.Width,Image.Height);
Center:=Point(Image.Width div 2,Image.Height div 2);
if Center.X<Center.Y then Radius:=Center.X
else Radius:=Center.Y;
end;


procedure DoKMeansClustering(Image: TImage);
var I: integer;
begin
ConfigureScreen(Image);
ClearImage(Image,clBlack);
for I:= 0 to N-1 do PolarRandom(Points[I]);    {random set of points}
 for I:= 0 to K-1 do PolarRandom(Cent[I]);    {random set of cluster centroids}
KMeans(Image);
end;
