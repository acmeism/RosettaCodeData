{-------------------------------------------------------------------------------}



type THistogram = record
 Bins: array [0..255] of integer;
 Colors: array [0..255] of TRGBTriple;
 end;


procedure MedianFilter(Src,Dest: TBitmap;  WindowX, WindowY: integer);
var x, y, X1, Y1, med, md, dl, delta_l, WX2, WY2: integer;
var I, MedSum, XStart,XEnd, YStart,YEnd, MedInx: integer;
var middle: integer;
var Histogram: THistogram;
var u: byte;
var Color: TRGBTriple;
var SrcRows,DestRows: TRGBTripleRowArray;
begin
WindowX:=WindowX * 2 -1;
WindowY:=WindowY * 2 -1;

Src.PixelFormat:=pf24Bit;
Dest.PixelFormat:=pf24Bit;

Dest.Width:=Src.Width;
Dest.Height:=Src.Height;
SetLength(SrcRows,Src.Height);
SetLength(DestRows,Dest.Height);

{Capture scan lines of both source and destiantion bitmaps}
for Y:=0 to Src.Height-1 do SrcRows[Y]:=Src.ScanLine[Y];
for Y:=0 to Dest.Height-1 do DestRows[Y]:=Dest.ScanLine[Y];


WX2 := WindowX div 2;
WY2 := WindowY div 2;

middle := (WindowX * WindowY-1) div 2;

for y := 0 to SRC.Height-1 do
	begin
	{ Determine the histogram and median for the first element of each row}
	YStart:=Y - WY2;
	YEnd:=Y + WY2;

	{ histogram reset }
	for I := 0 to 255 do Histogram.Bins[I] := 0;

	{recalculation of the histogram for the start element row=y, col=0 }
	for Y1 := YStart to YEnd do
	 for X1 := -WX2 to WX2 do
	 	begin
		{It is the first pixel on the row, so don't worry about right edge}
	 	if (Y1>=0) and (Y1<SRC.Height) and (X1>=0) then Color:=SrcRows[Y1][X1] else Color:=MakeRBGTriple(0,0,0); // Color:=SrcRows[y][0];
		U:=RGBToGray(Color);
	 	inc(Histogram.Bins[U]);
		Histogram.Colors[U]:=Color;
	 	end;

	 { now determine the median }
	 MedSum := 0;
	 for MedInx := 0 to 255 do
	 	begin
	 	inc(MedSum,Histogram.Bins[MedInx]);
	 	if MedSum > middle then break;
	 	end;
	 med := MedInx;

	 delta_l := MedSum - Histogram.Bins[MedInx];
         DestRows[Y][0]:=Histogram.Colors[MedInx];

	 { Loop through each column in this row}
	 for x := 1 to Src.Width-1 do
	 	begin
	 	XStart := x-wx2-1;
	 	XEnd := x+wx2;
	 	{ go to next column }
	 	for Y1 := YStart to YEnd do
	 		begin
	 		if (XStart >= 0) and (Y1 >= 0) and (Y1 < SRC.Height) then Color:=SrcRows[Y1][XStart] else Color:=MakeRBGTriple(0,0,0); //  Color:=SrcRows[Y][X];
	 		U:=RGBToGray(Color);
	 		if Histogram.Bins[u]>0 then dec(Histogram.Bins[u]);
	 		if u < med then dec(delta_l);
	 		if (XEnd < Src.Width) and (Y1 >= 0) and (Y1 < SRC.Height) then Color:=SrcRows[Y1][XEnd] else Color:=MakeRBGTriple(0,0,0); //  Color:=SrcRows[Y][X];
	 		U:=RGBToGray(Color);
	 		inc(Histogram.Bins[u]);
	 		Histogram.Colors[U]:=Color;
	 		if u < med then inc(delta_l);
	 		end;

	 	{ update new median }
	 	dl := delta_l;
	 	md := med;
	 	if dl > middle then
	 		begin
	 		while dl > middle do
	 			begin
	 			dec(md);
	 			if Histogram.Bins[md] > 0 then
	 			dec(dl,Histogram.Bins[md]);
	 			end;
	 		end
	 	else
	 		begin
	 		while dl + Histogram.Bins[md] <= middle do
	 			begin
	 			if Histogram.Bins[md] > 0 then inc(dl,Histogram.Bins[md]);
	 			inc(md);
	 			end;
	 		end;
	 	delta_l := dl;
	 	med := md;
	 	DestRows[Y][X]:= Histogram.Colors[med];
	 	end;   { x loop}
	 end; { y loop}
end;
