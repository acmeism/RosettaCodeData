{Array contain possiple winning lines}

type TWinLine = array [0..3-1] of TPoint;

var WinLines: array [0..8-1] of TWinLine = (
((X:0; Y:0), (X:1; Y:0), (X:2; Y:0)),
((X:0; Y:1), (X:1; Y:1), (X:2; Y:1)),
((X:0; Y:2), (X:1; Y:2), (X:2; Y:2)),
((X:0; Y:0), (X:0; Y:1), (X:0; Y:2)),
((X:1; Y:0), (X:1; Y:1), (X:1; Y:2)),
((X:2; Y:0), (X:2; Y:1), (X:2; Y:2)),
((X:0; Y:0), (X:1; Y:1), (X:2; Y:2)),
((X:2; Y:0), (X:1; Y:1), (X:0; Y:2))
);


{Array containing all characters in a line}

type TCellArray = array [0..3-1] of char;

var WinLineInx: integer;
var GameOver: boolean;

procedure ClearGrid;
{Clear TTT Grid by setting all cells to a space}
var X,Y: integer;
begin
with TicTacToeDlg do
 begin
 for Y:=0 to GameGrid.RowCount-1 do
  for X:=0 to GameGrid.ColCount-1 do GameGrid.Cells[X,Y]:=' ';
 WinLineInx:=-1;
 Status1Dis.Caption:='';
 GameOver:=False;
 end;

end;


function FirstEmptyCell(var P: TPoint): boolean;
{Find first empty grid i.e. the one containing a space}
{Returns false if there are no empty cells (a tie game)}
var X,Y: integer;
begin
Result:=True;
with TicTacToeDlg do
 begin
 {Iterate through all cells in array}
 for Y:=0 to GameGrid.RowCount-1 do
  for X:=0 to GameGrid.ColCount-1 do
   if GameGrid.Cells[X,Y]=' ' then
	begin
	P.X:=X; P.Y:=Y;
	Exit;
	end;
 end;
Result:=False;
end;



procedure GetLineChars(Inx: integer; var CA: TCellArray);
{Get all the characters in a specific win line}
var P1,P2,P3: TPoint;
begin
with TicTacToeDlg do
 begin
 {Get cell position of specific win line}
 P1:=WinLines[Inx,0];
 P2:=WinLines[Inx,1];
 P3:=WinLines[Inx,2];
 {Get the characters from each and put in array}
 CA[0]:=GameGrid.Cells[P1.X,P1.Y][1];
 CA[1]:=GameGrid.Cells[P2.X,P2.Y][1];
 CA[2]:=GameGrid.Cells[P3.X,P3.Y][1];
 end;
end;



function IsWinner(var Inx: integer; var C: char): boolean;
{Test if the specified line is a winner}
{Return index of line and the char of winner}
var I,J: integer;
var CA: TCellArray;
begin
with TicTacToeDlg do
 begin
 Result:=False;
 {Go through all winning patterns}
 for J:=0 to High(WinLines) do
	begin
	{Get one winning pattern}
	GetLineChars(J,CA);
	{Look for line that has the same char in all three places}
	if (CA[0]<>' ') and (CA[0]=CA[1]) and (CA[0]=CA[2]) then
		begin
		Result:=True;
		Inx:=J;
		C:=CA[0];
		end;
	end;

 end;
end;


procedure DrawWinLine(Inx: integer);
{Draw line through winning squares}
var Line: TWinLine;
var C1,C2: TPoint;
var P1,P2: TPoint;
var W2,H2: integer;
begin
with TicTacToeDlg do
 begin
 {Offset to center of cell}
 W2:=GameGrid.ColWidths[0] div 2;
 H2:=GameGrid.RowHeights[0] div 2;
 {Get winning pattern of lines}
 Line:=WinLines[Inx];
 {Get beginning and ending cell of win}
 C1:=Line[0]; C2:=Line[2];
 {Convert to screen coordinates}
 P1.X:=C1.X * GameGrid.ColWidths[0] + W2;
 P1.Y:=C1.Y * GameGrid.RowHeights[0] + H2;
 P2.X:=C2.X * GameGrid.ColWidths[0] + W2;
 P2.Y:=C2.Y * GameGrid.RowHeights[0] + H2;
 {Set line attributes}
 GameGrid.Canvas.Pen.Color:=clRed;
 GameGrid.Canvas.Pen.Width:=5;
 {Draw line}
 GameGrid.Canvas.MoveTo(P1.X,P1.Y);
 GameGrid.Canvas.LineTo(P2.X,P2.Y);
 end;
end;



procedure DoBestComputerMove;
{Analyze game board and execute the best computer move}
var I,J,Inx: integer;
var CA: TCellArray;
var P: TPoint;


	function UrgentMove(CA: TCellArray; var EmptyInx: integer): boolean;
	{Test row, column or diagonal for  an urgent move}
	{This would be either an immediate win or immediate loss}
	{Returns True if there is an urgent move and the index of location to respond}
	var I: integer;
	var OCnt,XCnt,EmptyCnt: integer;
	begin
	Result:=False;
	OCnt:=0; XCnt:=0;
	EmptyCnt:=0; EmptyInx:=-1;
	{Count number of Xs, Os or Spaces in line}
	for I:=0 to High(CA) do
		begin
		case CA[I] of
		 'O': Inc(OCnt);
		 'X': Inc(XCnt);
		 ' ':
		 	begin
		 	Inc(EmptyCnt);
		 	if EmptyCnt=1 then EmptyInx:=I;
		 	end;
		 end;
		end;
	{Look for pattern of one empty and two Xs or two Os}
	{Which means it's one move away from a win}
	Result:=(EmptyCnt=1) and ((OCnt=2) or (XCnt=2));
	end;


begin
with TicTacToeDlg do
 begin
 {Look for urgent moves in all patterns of wins}
 for J:=0 to High(WinLines) do
	begin
	{Get a winning pattern of chars}
	GetLineChars(J,CA);
	if UrgentMove(CA,Inx) then
		begin
		{Urgent move found - take it}
		P:=WinLines[J,Inx];
                GameGrid.Cells[P.X,P.Y]:='O';
		exit;
		end;
	end;
 {No urgent moves, so use first empty}
 {If there is no empty, the game is stalemated}
 if FirstEmptyCell(P) then GameGrid.Cells[P.X,P.Y]:='O';
 end;
end;


function TestWin: boolean;
{Test if last move resulted in win/draw}
var Inx: integer; var C: char;
var P: TPoint;
var S: string;
begin
Result:=True;
{Test if somebody won}
if IsWinner(Inx,C) then
	begin
	WinLineInx:=Inx;
	TicTacToeDlg.GameGrid.Invalidate;
	if C='O' then S:=' Computer Won!!' else S:=' You Won!!';
        TicTacToeDlg.Status1Dis.Caption:=S;
	GameOver:=True;
	exit;
	end;
{Test if game is a draw}
if not FirstEmptyCell(P) then
	begin
        TicTacToeDlg.Status1Dis.Caption:=' Game is Draw.';
	GameOver:=True;
	exit;
	end;
Result:=False;
end;


procedure PlayTicTacToe;
{Show TicTacToe dialog box}
begin
ClearGrid;
TicTacToeDlg.ShowModal
end;



procedure TTicTacToeDlg.GameGridMouseDown(Sender: TObject;
  Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
{Handle user click on TicTacToe grid}
var Row,Col: integer;
begin
with TicTacToeDlg do
 begin
 if GameOver then exit;;
 {Convert Mouse X,Y to Grid row and column}
 GameGrid.MouseToCell(X,Y,Col,Row);
 {Mark user's selection by placing X in the cell}
 if GameGrid.Cells[Col,Row]=' 'then
    GameGrid.Cells[Col,Row]:='X';
 {Did this result in a win? }
 if TestWin then exit;
 {Get computer's response}
 DoBestComputerMove;
 {Did computer win}
 TestWin;
 end;
end;

procedure TTicTacToeDlg.ReplayBtnClick(Sender: TObject);
begin
ClearGrid;
end;



procedure TTicTacToeDlg.GameGridDrawCell(Sender: TObject; ACol,
  ARow: Integer; Rect: TRect; State: TGridDrawState);
{Draw winner line on top of Xs and Os}
begin
if WinLineInx>=0 then DrawWinLine(WinLineInx);
end;
