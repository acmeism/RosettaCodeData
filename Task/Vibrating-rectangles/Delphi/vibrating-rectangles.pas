const ColorMap47: array [0..46] of TColor = (
	0 or (0 shl 8) or (0 shl 16),
	255 or (224 shl 8) or (224 shl 16),
	255 or (212 shl 8) or (212 shl 16),
	255 or (169 shl 8) or (169 shl 16),
	255 or (127 shl 8) or (127 shl 16),
	255 or (84 shl 8) or (84 shl 16),
	255 or (42 shl 8) or (42 shl 16),
	255 or (0 shl 8) or (0 shl 16),
	255 or (13 shl 8) or (0 shl 16),
	255 or (26 shl 8) or (0 shl 16),
	255 or (40 shl 8) or (0 shl 16),
	255 or (53 shl 8) or (0 shl 16),
	255 or (67 shl 8) or (0 shl 16),
	255 or (80 shl 8) or (0 shl 16),
	255 or (93 shl 8) or (0 shl 16),
	255 or (107 shl 8) or (0 shl 16),
	255 or (120 shl 8) or (0 shl 16),
	255 or (134 shl 8) or (0 shl 16),
	255 or (147 shl 8) or (0 shl 16),
	255 or (161 shl 8) or (0 shl 16),
	255 or (174 shl 8) or (0 shl 16),
	255 or (187 shl 8) or (0 shl 16),
	255 or (201 shl 8) or (0 shl 16),
	255 or (214 shl 8) or (0 shl 16),
	255 or (228 shl 8) or (0 shl 16),
	255 or (241 shl 8) or (0 shl 16),
	255 or (255 shl 8) or (0 shl 16),
	236 or (248 shl 8) or (0 shl 16),
	218 or (242 shl 8) or (0 shl 16),
	200 or (235 shl 8) or (0 shl 16),
	183 or (229 shl 8) or (0 shl 16),
	167 or (223 shl 8) or (0 shl 16),
	151 or (216 shl 8) or (0 shl 16),
	136 or (210 shl 8) or (0 shl 16),
	122 or (204 shl 8) or (0 shl 16),
	108 or (197 shl 8) or (0 shl 16),
	95 or (191 shl 8) or (0 shl 16),
	83 or (185 shl 8) or (0 shl 16),
	71 or (178 shl 8) or (0 shl 16),
	60 or (172 shl 8) or (0 shl 16),
	49 or (166 shl 8) or (0 shl 16),
	39 or (159 shl 8) or (0 shl 16),
	30 or (153 shl 8) or (0 shl 16),
	22 or (147 shl 8) or (0 shl 16),
	14 or (140 shl 8) or (0 shl 16),
	6 or (134 shl 8) or (0 shl 16),
	0 or (128 shl 8) or (0 shl 16));


procedure DrawVibratingRectangles(Image: TImage);
var StartRect,WR: TRect;
const PenSize = 2;
var I,J,Offset: integer;
begin
StartRect:=Rect(0,0,Image.Width,Image.Height);
Image.Canvas.Pen.Width:=PenSize;
Image.Canvas.Brush.Style:=bsClear;
Offset:=0;
{Run for 100 seconds}
for J:=0 to 1000 do
	begin
	{Start with Window-sized rect}
	WR:=StartRect;
	for I:=0 to 100 do
		begin
		{Draw rectangle}
		Image.Canvas.Pen.Color:=ColorMap47[(I+Offset) mod Length(ColorMap47)];
		Image.Canvas.Rectangle(WR);
		{Shrink rect by twice the pen width}
		InflateRect(WR,-PenSize*2,-PenSize*2);
		end;
	Image.Repaint;
	Inc(Offset);
	Application.ProcessMessages;
	if AbortFlag or Application.Terminated then break;
	Sleep(100);
	end;
end;

