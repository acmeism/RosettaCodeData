procedure DrawBar(Image: TImage; Bars,Rows,Row: integer; WhiteToBlack: boolean);
{Draw horizontal bar according the following parameters:}
{Bars = number of color bars to fit into the horizontal space}
{Rows = number of rows to fit into the vertical space}
{Row = the row to place the current bar - numbered 0..n, top to bottom}
{WhiteToBlack - if true, bars in the row go from white to back}
var X: integer;
var Color: integer;
var ColorStep: double;
var BarHeight: integer;
var R,R2: TRect;
begin
{Calculate bar dimensions}
BarHeight:=Image.Height div Rows;
R:=Rect(0,0,(Image.Width div Bars)+1, BarHeight);
OffsetRect(R,0,BarHeight * Row);
R2:=R;
{Calculate color parameters}
ColorStep:=255/(Bars-1);
if WhiteToBlack then
	begin
	Color:=255;
	ColorStep:=-ColorStep
	end
else Color:=0;
{Draw bars}
for X:=1 to Bars do
	begin
	{Set color}
	Image.Canvas.Brush.Color:=RGB(Color,Color,Color);
	Image.Canvas.Pen.Color:=RGB(Color,Color,Color);
	{Draw rectangular bar}
	Image.Canvas.Rectangle(R2);
	{Move rectangle and calculate color}
	OffsetRect(R2,R.Right,0);
	Color:=Round(X * ColorStep);
	end;
end;


procedure ShowGrayBars(Image: TImage);
{Draw four bar, with alternating color scheme}
begin
DrawBar(Image,8,4,0,False);
DrawBar(Image,16,4,1,True);
DrawBar(Image,32,4,2,False);
DrawBar(Image,64,4,3,True);
end;
