const BoardWidth = 4; BoardHeight = 4;
const CellCount = BoardWidth * BoardHeight;

var GameBoard: array [0..BoardWidth-1,0..BoardHeight-1] of integer;


procedure BuildBoard;
{Put all number in the game board}
var I,X,Y: integer;
begin
for I:=0 to CellCount-1 do
	begin
	Y:=I div BoardHeight;
	X:=I mod BoardWidth;
	GameBoard[X,Y]:=I;
	end;
end;


function IsWinner: boolean;
{Check to see if tiles are winning in order}
var I,X,Y: integer;
begin
Result:=False;
for I:=1 to CellCount-1 do
	begin
	Y:=(I-1) div BoardHeight;
	X:=(I-1) mod BoardWidth;
	if GameBoard[X,Y]<>I then exit;
	end;
Result:=True;
end;


procedure DisplayGameBoard(Grid: TStringGrid);
{Display game on TStringGrid component}
var Tile,X,Y: integer;
var S: string;
begin
for Y:=0 to High(GameBoard) do
	begin
	S:='';
	for X:=0 to High(GameBoard[0]) do
		begin
		Tile:=GameBoard[X,Y];
		if Tile=0 then Form1.GameGrid.Cells[X,Y]:=''
		else Grid.Cells[X,Y]:=IntToStr(GameBoard[X,Y]);
		end;
	end;
end;



procedure ExchangePieces(P1,P2: TPoint);
{Exchange the pieces specified by P1 and P2}
var T: integer;
begin
T:=GameBoard[P1.X,P1.Y];
GameBoard[P1.X,P1.Y]:=GameBoard[P2.X,P2.Y];
GameBoard[P2.X,P2.Y]:=T;
end;


procedure Randomize;
{Scramble piece by exchanging random pieces}
var I: integer;
var P1,P2: TPoint;
begin
for I:=0 to 100 do
	begin
	P1:=Point(Random(BoardWidth),Random(BoardHeight));
	P2:=Point(Random(BoardWidth),Random(BoardHeight));
	ExchangePieces(P1,P2);
	end;
end;


procedure NewGame;
{Initiate new game by randomizing tiles}
begin
BuildBoard;
Randomize;
DisplayGameBoard(Form1.GameGrid);
end;



function FindEmptyNeighbor(P: TPoint): TPoint;
{Find the empty neighbor cell if any}
{Returns Point(-1,-1) if none found}
begin
Result:=Point(-1,-1);
if (P.X>0) and (GameBoard[P.X-1,P.Y]=0) then Result:=Point(P.X-1,P.Y)
else if (P.X<(BoardWidth-1)) and (GameBoard[P.X+1,P.Y]=0) then Result:=Point(P.X+1,P.Y)
else if (P.Y>0) and (GameBoard[P.X,P.Y-1]=0) then Result:=Point(P.X,P.Y-1)
else if (P.Y<(BoardHeight-1)) and (GameBoard[P.X,P.Y+1]=0) then Result:=Point(P.X,P.Y+1);
end;



procedure ShowStatus(S: string; BellCount: integer);
{Display status string and ring bell specified number of times}
var I: integer;
begin
Form1.StatusMemo.Lines.Add(S);
for I:=1 to BellCount do PlaySound('DeviceFail', 0, SND_SYNC);
end;



procedure HandleMouseClick(X,Y: integer; Grid: TStringGrid);
{Handle mouse click on specified grid}
var Pos,Empty: TPoint;
var Item: integer;
begin
Grid.MouseToCell(X, Y,Pos.X, Pos.Y);
Item:=GameBoard[Pos.X,Pos.Y];
Empty:=FindEmptyNeighbor(Pos);
if (Item>0) and (Empty.X>=0) then
	begin
	ExchangePieces(Empty,Pos);
	DisplayGameBoard(Grid);
	if IsWinner then ShowStatus('Winner', 5);
	end
else ShowStatus('Invalid Command.', 1);
end;



procedure TForm1.NewGameBtnClick(Sender: TObject);
{Create new game when button pressed}
begin
NewGame;
end;


procedure TForm1.GameGridMouseDown(Sender: TObject; Button: TMouseButton;
  Shift: TShiftState; X, Y: Integer);
{Use the mouse click event to select a move}
begin
HandleMouseClick(X,Y,GameGrid);
end;

procedure TForm1.FormCreate(Sender: TObject);
{Start new game when the program starts running}
begin
NewGame;
end;
