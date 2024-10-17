{ These routines would normally be in a library,
but are presented here for clarity }

function PointAdd(V1,V2: TPoint): TPoint;
{Add V1 and V2}
begin
Result.X:= V1.X+V2.X;
Result.Y:= V1.Y+V2.Y;
end;


const KnightMoves: array [0..7] of TPoint = (
	(X: 2; Y:1),(X: 2; Y:-1),
	(X:-2; Y:1),(X:-2; Y:-1),
	(X:1; Y: 2),(X:-1; Y: 2),
	(X:1; Y:-2),(X:-1; Y:-2));

var Board: array [0..7,0..7] of boolean;

var Path: array of TPoint;

var CellSize,BoardSize: integer;

var CurPos: TPoint;

var BestPath: integer;

{-------------------------------------------------------------}

procedure DrawBestPath(Image: TImage);
begin
Image.Canvas.TextOut(BoardSize+5,5, IntToStr(BestPath));
end;


procedure PushPath(P: TPoint);
begin
SetLength(Path,Length(Path)+1);
Path[High(Path)]:=P;
if Length(Path)>BestPath then BestPath:=Length(Path);
end;


function PopPath: TPoint;
begin
if Length(Path)<1 then exit;
Result:=Path[High(Path)];
SetLength(Path,Length(Path)-1);
end;


procedure ClearPath;
begin
SetLength(Path,0);
end;

{-------- Routines to draw chess board and path --------------}

function GetCellCenter(P: TPoint): TPoint;
{Get pixel position of the center of cell}
begin
Result.X:=CellSize div 2 + CellSize * P.X;
Result.Y:=CellSize div 2 + CellSize * P.Y;
end;



procedure DrawPoint(Canvas: TCanvas; P: TPoint);
{Draw a point on the board}
begin
Canvas.Pen.Color:=clYellow;
Canvas.MoveTo(P.X-1,P.Y-1);
Canvas.LineTo(P.X+1,P.Y+1);
Canvas.MoveTo(P.X+1,P.Y-1);
Canvas.LineTo(P.X-1,P.Y+1);
end;


procedure DrawPathLine(Canvas: TCanvas; P1,P2: TPoint);
{Draw the path line}
var PS1,PS2: TPoint;
begin
PS1:=GetCellCenter(P1);
PS2:=GetCellCenter(P2);
Canvas.Pen.Width:=5;
Canvas.Pen.Color:=clRed;
Canvas.MoveTo(PS1.X,PS1.Y);
Canvas.LineTo(PS2.X,PS2.Y);
DrawPoint(Canvas,PS1);
DrawPoint(Canvas,PS2);
end;


procedure DrawPath(Canvas: TCanvas);
{Draw all points on the path}
var I: integer;
begin
for I:=0 to High(Path)-1 do
	begin
	DrawPathLine(Canvas, Path[I],Path[I+1]);
	end;
end;


procedure DrawBoard(Canvas: TCanvas);
{Draw the chess board}
var R,R2: TRect;
var X,Y: integer;
var Color: TColor;
begin
Canvas.Pen.Color:=clBlack;
R:=Rect(0,0,BoardSize,BoardSize);
Canvas.Rectangle(R);
R:=Rect(0,0,CellSize,CellSize);
for Y:=0 to High(Board[0]) do
 for X:=0 to High(Board) do
	begin
	R2:=R;
	if ((X+Y) mod 2)=0 then Color:=clWhite
	else Color:=clBlack;
	Canvas.Brush.Color:=Color;
	OffsetRect(R2,X * CellSize, Y * CellSize);
	Canvas.Rectangle(R2);
	end;
DrawPath(Canvas);
end;


function AllVisited: boolean;
{Test if all squares have been visit by path}
var X,Y: integer;
begin
Result:=False;
for Y:=0 to High(Board[0]) do
 for X:=0 to High(Board) do
  if not Board[X,Y] then exit;
Result:=True;
end;



procedure ClearBoard;
{Clear all board positions}
var X,Y: integer;
begin
for Y:=0 to High(Board[0]) do
 for X:=0 to High(Board) do
 Board[X,Y]:=False;
end;



function IsValidMove(Pos,Move: TPoint): boolean;
{Test if potential move is valid}
var NP: TPoint;
begin
Result:=False;
NP:=PointAdd(Pos,Move);
if (NP.X<0) or (NP.X>High(Board)) or
   (NP.Y<0) or (NP.Y>High(Board[0])) then exit;
if Board[NP.X,NP.Y] then exit;
Result:=True;
end;


procedure ConfigureScreen(Image: TImage);
{Configure screen size}
begin
if Image.Width<Image.Height then BoardSize:=Image.Width
else BoardSize:=Image.Height;
CellSize:=BoardSize div 8;
end;




procedure SetPosition(Image: TImage; P: TPoint; Value: boolean);
{Set a new position by adding it to path}
{Marking position as used and redrawing board}
begin
if Value then PushPath(P)
else P:=PopPath;
Board[P.X,P.Y]:=Value;
DrawBoard(Image.Canvas);
DrawBestPath(Image);
Image.Repaint;
end;



procedure TryAllMoves(Image: TImage; Pos: TPoint);
{Recursively try all moves}
var I: integer;
var NewPos: TPoint;
begin
SetPosition(Image,Pos,True);
if AllVisited then exit;
for I:=0 to High(KnightMoves) do
	begin
	if AbortFlag then Exit;
	if IsValidMove(Pos,KnightMoves[I]) then
		begin
		NewPos:=PointAdd(Pos,KnightMoves[I]);
		TryAllMoves(Image,NewPos);
		end;
	end;
SetPosition(Image,Pos,False);
Application.ProcessMessages;
end;


procedure DoKnightsTour(Image: TImage);
{Solve Knights tour by testing all paths}
begin
BestPath:=0;
ConfigureScreen(Image);
ClearPath;
ClearBoard;
DrawBoard(Image.Canvas);
TryAllMoves(Image, Point(0,0));
end;
