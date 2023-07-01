program fifteen;
{$mode objfpc}
{$modeswitch advancedrecords}
{$coperators on}
uses
  SysUtils, crt;
type
  TPuzzle = record
  private
  const
    ROW_COUNT  = 4;
    COL_COUNT  = 4;
    CELL_COUNT = ROW_COUNT * COL_COUNT;
    RAND_RANGE = 101;
  type
    TTile          = 0..Pred(CELL_COUNT);
    TAdjacentCell  = (acLeft, acTop, acRight, acBottom);
    TPossibleMoves = set of TTile;
    TCellAdjacency = set of TAdjacentCell;
    TBoard         = array[0..Pred(CELL_COUNT)] of TTile;
  class var
    HBar: string;
  var
    FBoard: TBoard;
    FZeroPos,
    FMoveCount: Integer;
    FZeroAdjacency: TCellAdjacency;
    FPossibleMoves: TPossibleMoves;
    FSolved: Boolean;
    procedure DoMove(aTile: TTile);
    procedure CheckPossibleMoves;
    procedure PrintBoard;
    procedure PrintPossibleMoves;
    procedure TestSolved;
    procedure GenerateBoard;
    class constructor Init;
  public
    procedure New;
    function  UserMoved: Boolean;
    property  MoveCount: Integer read FMoveCount;
    property  Solved: Boolean read FSolved;
  end;

procedure TPuzzle.DoMove(aTile: TTile);
var
  Pos: Integer = -1;
  Adj: TAdjacentCell;
begin
  for Adj in FZeroAdjacency do
    begin
      case Adj of
        acLeft:   Pos := Pred(FZeroPos);
        acTop:    Pos := FZeroPos - COL_COUNT;
        acRight:  Pos := Succ(FZeroPos);
        acBottom: Pos := FZeroPos + COL_COUNT;
      end;
      if FBoard[Pos] = aTile then
        break;
    end;
  FBoard[FZeroPos] := aTile;
  FZeroPos := Pos;
  FBoard[Pos] := 0;
end;

procedure TPuzzle.CheckPossibleMoves;
var
  Row, Col: Integer;
begin
  Row := FZeroPos div COL_COUNT;
  Col := FZeroPos mod COL_COUNT;
  FPossibleMoves := [];
  FZeroAdjacency := [];
  if Row > 0 then
    begin
      FPossibleMoves += [FBoard[FZeroPos - COL_COUNT]];
      FZeroAdjacency += [acTop];
    end;
  if Row < Pred(ROW_COUNT) then
    begin
      FPossibleMoves += [FBoard[FZeroPos + COL_COUNT]];
      FZeroAdjacency += [acBottom];
    end;
  if Col > 0 then
    begin
      FPossibleMoves += [FBoard[Pred(FZeroPos)]];
      FZeroAdjacency += [acLeft];
    end;
  if Col < Pred(COL_COUNT) then
    begin
      FPossibleMoves += [FBoard[Succ(FZeroPos)]];
      FZeroAdjacency += [acRight];
    end;
end;

procedure TPuzzle.PrintBoard;
const
  Space = ' ';
  VBar  = '|';
  VBar1 = '| ';
  VBar2 = '|  ';
  VBar3 = '|    ';
var
  I, J, Pos, Tile: Integer;
  Row: string;
begin
  ClrScr;
  Pos := 0;
  WriteLn(HBar);
  for I := 1 to ROW_COUNT do
    begin
      Row := '';
      for J := 1 to COL_COUNT do
        begin
          Tile := Integer(FBoard[Pos]);
          case Tile of
            0:    Row += VBar3;
            1..9: Row += VBar2 + Tile.ToString + Space;
          else
            Row += VBar1 + Tile.ToString + Space;
          end;
          Inc(Pos);
        end;
      WriteLn(Row + VBar);
      WriteLn(HBar);
    end;
  if not Solved then
    PrintPossibleMoves;
end;

procedure TPuzzle.PrintPossibleMoves;
var
  pm: TTile;
  spm: string = '';
begin
  for pm in FPossibleMoves do
    spm += Integer(pm).ToString + ' ';
  WriteLn('possible moves: ', spm);
end;

procedure TPuzzle.TestSolved;
  function IsSolved: Boolean;
  var
    I: Integer;
  begin
    for I := 0 to CELL_COUNT - 3 do
      if FBoard[I] <> Pred(FBoard[Succ(I)]) then
        exit(False);
    Result := True;
  end;
begin
  FSolved := IsSolved;
  if not Solved then
    CheckPossibleMoves;
end;

procedure TPuzzle.GenerateBoard;
var
  I, CurrMove, SelMove: Integer;
  Tile: TTile;
begin
  FZeroPos := Pred(CELL_COUNT);
  FBoard[FZeroPos] := 0;
  for I := 0 to CELL_COUNT - 2 do
    FBoard[I] := Succ(I);
  for I := 1 to Random(RAND_RANGE) do
    begin
      CheckPossibleMoves;
      SelMove := 0;
      for Tile in FPossibleMoves do
        Inc(SelMove);
      SelMove := Random(SelMove);
      CurrMove := 0;
      for Tile in FPossibleMoves do
        begin
          if CurrMove = SelMove then
            begin
              DoMove(Tile);
              break;
            end;
          Inc(CurrMove);
        end;
    end;
end;

class constructor TPuzzle.Init;
var
  I: Integer;
begin
  HBar := '';
  for I := 1 to COL_COUNT do
    HBar += '+----';
  HBar += '+';
end;

procedure TPuzzle.New;
begin
  FSolved := False;
  FMoveCount := 0;
  GenerateBoard;
  CheckPossibleMoves;
  PrintBoard;
end;

function TPuzzle.UserMoved: Boolean;
const
  Sorry          = 'sorry, ';
  InvalidInput   = ' is invalid input';
  ImpossibleMove = ' is impossible move';
var
  UserInput: string;
  Tile: Integer = 0;
begin
  ReadLn(UserInput);
  case LowerCase(UserInput) of
    'c', 'cancel': exit(False);
  end;
  Result := True;
  if not Tile.TryParse(UserInput, Tile) then
    begin
      WriteLn(Sorry, UserInput, InvalidInput);
      exit;
    end;
  if not (Tile in [1..Pred(CELL_COUNT)]) then
    begin
      WriteLn(Sorry, Tile, InvalidInput);
      exit;
    end;
  if not (Tile in FPossibleMoves) then
    begin
      WriteLn(Sorry, Tile, ImpossibleMove);
      PrintPossibleMoves;
      exit;
    end;
  DoMove(Tile);
  Inc(FMoveCount);
  TestSolved;
  PrintBoard;
end;

procedure PrintStart;
begin
  ClrScr;
  WriteLn('Fifteen puzzle start:');
  WriteLn('  enter a tile number and press <enter> to move' );
  WriteLn('  enter Cancel(C) and press <enter> to exit' );
  Window(10, 4, 58, 21);
end;

procedure Terminate;
begin
  ClrScr;
  Window(1, 1, 80, 25);
  ClrScr;
  WriteLn('Fifteen puzzle exit.');
  Halt;
end;

function UserWantContinue(aMoveCount: Integer): Boolean;
var
  UserInput: string;
begin
  WriteLn('Congratulations! Puzzle solved in ', aMoveCount, ' moves.');
  WriteLn('Play again(Yes(Y)/<any button>)?');
  ReadLn(UserInput);
  case LowerCase(UserInput) of
    'y', 'yes': exit(True);
  end;
  Result := False;
end;

procedure Run;
var
  Puzzle: TPuzzle;
begin
  Randomize;
  PrintStart;
  repeat
    Puzzle.New;
    while not Puzzle.Solved do
      if not Puzzle.UserMoved then
        Terminate;
    if not UserWantContinue(Puzzle.MoveCount) then
      Terminate;
  until False;
end;

begin
  Run;
end.
