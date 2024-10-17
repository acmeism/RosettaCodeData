program Game2048;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Math,
  Velthuis.Console;

type
  TTile = class
    Value: integer;
    IsBlocked: Boolean;
    constructor Create;
  end;

  TMoveDirection = (mdUp, mdDown, mdLeft, mdRight);

  TG2048 = class
    FisDone, FisWon, FisMoved: boolean;
    Fscore: Cardinal;
    FBoard: array[0..3, 0..3] of TTile;
    function GetLine(aType: byte): string;
  public
    constructor Create;
    destructor Destroy; override;
    procedure InitializeBoard();
    procedure FinalizeBoard();
    procedure Loop;
    procedure DrawBoard();
    procedure WaitKey();
    procedure AddTile();
    function CanMove(): boolean;
    function TestAdd(x, y, value: Integer): boolean;
    procedure MoveHorizontally(x, y, d: integer);
    procedure MoveVertically(x, y, d: integer);
    procedure Move(direction: TMoveDirection);
  end;


{ TTile }

constructor TTile.Create;
begin
  Value := 0;
  IsBlocked := false;
end;

{ TG2048 }

procedure TG2048.AddTile;
var
  y, x, a, b: Integer;
  r: Double;
begin
  for y := 0 to 3 do
  begin
    for x := 0 to 3 do
    begin
      if Fboard[x, y].Value <> 0 then
        continue;
      repeat
        a := random(4);
        b := random(4);
      until not (Fboard[a, b].Value <> 0);
      r := Random;
      if r > 0.89 then
        Fboard[a, b].Value := 4
      else
        Fboard[a, b].Value := 2;
      if CanMove() then
      begin
        Exit;
      end;
    end;
  end;
  FisDone := true;
end;

function TG2048.CanMove: boolean;
var
  y, x: Integer;
begin
  for y := 0 to 3 do
  begin
    for x := 0 to 3 do
    begin
      if Fboard[x, y].Value = 0 then
      begin
        Exit(true);
      end;
    end;
  end;
  for y := 0 to 3 do
  begin
    for x := 0 to 3 do
    begin
      if TestAdd(x + 1, y, Fboard[x, y].Value) or TestAdd(x - 1, y, Fboard[x, y].Value)
        or TestAdd(x, y + 1, Fboard[x, y].Value) or TestAdd(x, y - 1, Fboard[x,
        y].Value) then
      begin
        Exit(true);
      end;
    end;
  end;
  Exit(false);
end;

constructor TG2048.Create;
begin
  FisDone := false;
  FisWon := false;
  FisMoved := true;
  Fscore := 0;
  InitializeBoard();
  Randomize;
end;

destructor TG2048.Destroy;
begin
  FinalizeBoard;
  inherited;
end;

procedure TG2048.DrawBoard;
var
  y, x: Integer;
  color: byte;
  lineFragment, line: string;
begin
  ClrScr;
  HighVideo;
  writeln('Score: ', Fscore: 3, #10);
  TextBackground(White);
  TextColor(black);
  for y := 0 to 3 do
  begin
    if y = 0 then
      writeln(GetLine(0))
    else
      writeln(GetLine(1));

    Write('  '#$2551' ');
    for x := 0 to 3 do
    begin
      if Fboard[x, y].Value = 0 then
      begin
        Write('    ');
      end
      else
      begin
        color := Round(Log2(Fboard[x, y].Value));
        TextColor(14 - color);
        Write(Fboard[x, y].Value: 4);
        TextColor(Black);
      end;
      Write(' '#$2551' ');
    end;
    writeln(' ');
  end;
  writeln(GetLine(2), #10#10);
  TextBackground(Black);
  TextColor(White);
end;

procedure TG2048.FinalizeBoard;
var
  y, x: integer;
begin
  for y := 0 to 3 do
    for x := 0 to 3 do
      FBoard[x, y].Free;
end;

function TG2048.GetLine(aType: byte): string;
var
  fragment, line: string;
  bgChar, edChar, mdChar: char;
begin

  case aType of
    0:
      begin
        bgChar := #$2554;
        edChar := #$2557;
        mdChar := #$2566;
      end;
    1:
      begin
        bgChar := #$2560;
        edChar := #$2563;
        mdChar := #$256C;
      end;

    2:
      begin
        bgChar := #$255A;
        edChar := #$255D;
        mdChar := #$2569;
      end;
  end;
  fragment := string.create(#$2550, 6);
  line := fragment + mdChar + fragment + mdChar + fragment + mdChar + fragment;
  Result := '  '+bgChar + line + edChar + '  ';
end;

procedure TG2048.InitializeBoard;
var
  y, x: integer;
begin
  for y := 0 to 3 do
    for x := 0 to 3 do
      FBoard[x, y] := TTile.Create;
end;

procedure TG2048.Loop;
begin
  AddTile();
  while (true) do
  begin
    if (FisMoved) then
      AddTile();

    DrawBoard();
    if (FisDone) then
      break;

    WaitKey();
  end;

  if FisWon then
    Writeln('You''ve made it!')
  else
    Writeln('Game Over!');
end;

procedure TG2048.Move(direction: TMoveDirection);
var
  x, y: Integer;
begin
  case direction of
    mdUp:
      begin
        for x := 0 to 3 do
        begin
          y := 1;
          while y < 4 do
          begin
            if Fboard[x, y].Value <> 0 then
              MoveVertically(x, y, -1);
            Inc(y);
          end;
        end;
      end;
    mdDown:
      begin
        for x := 0 to 3 do
        begin
          y := 2;
          while y >= 0 do
          begin
            if Fboard[x, y].Value <> 0 then
              MoveVertically(x, y, 1);
            Dec(y);
          end;
        end;
      end;
    mdLeft:
      begin
        for y := 0 to 3 do
        begin
          x := 1;
          while x < 4 do
          begin
            if Fboard[x, y].Value <> 0 then
              MoveHorizontally(x, y, -1);
            Inc(x);
          end;
        end;
      end;
    mdRight:
      begin
        for y := 0 to 3 do
        begin
          x := 2;
          while x >= 0 do
          begin
            if Fboard[x, y].Value <> 0 then
              MoveHorizontally(x, y, 1);
            Dec(x);
          end;
        end;
      end;
  end;
end;

procedure TG2048.MoveHorizontally(x, y, d: integer);
begin
  if (FBoard[x + d, y].Value <> 0) and (FBoard[x + d, y].Value = FBoard[x, y].Value)
    and (not FBoard[x + d, y].IsBlocked) and (not FBoard[x, y].IsBlocked) then
  begin
    FBoard[x, y].Value := 0;
    FBoard[x + d, y].Value := FBoard[x + d, y].Value * 2;
    Fscore := Fscore + (FBoard[x + d, y].Value);
    FBoard[x + d, y].IsBlocked := true;
    FisMoved := true;
  end
  else if ((FBoard[x + d, y].Value = 0) and (FBoard[x, y].Value <> 0)) then
  begin
    FBoard[x + d, y].Value := FBoard[x, y].Value;
    FBoard[x, y].Value := 0;
    FisMoved := true;
  end;
  if d > 0 then
  begin
    if x + d < 3 then
    begin
      MoveHorizontally(x + d, y, 1);
    end;
  end
  else
  begin
    if x + d > 0 then
    begin
      MoveHorizontally(x + d, y, -1);
    end;
  end;
end;

procedure TG2048.MoveVertically(x, y, d: integer);
begin
  if (Fboard[x, y + d].Value <> 0) and (Fboard[x, y + d].Value = Fboard[x, y].Value)
    and (not Fboard[x, y].IsBlocked) and (not Fboard[x, y + d].IsBlocked) then
  begin
    Fboard[x, y].Value := 0;
    Fboard[x, y + d].Value := Fboard[x, y + d].Value * 2;
    Fscore := Fscore + (Fboard[x, y + d].Value);
    Fboard[x, y + d].IsBlocked := true;
    FisMoved := true;
  end
  else if ((Fboard[x, y + d].Value = 0) and (Fboard[x, y].Value <> 0)) then
  begin
    Fboard[x, y + d].Value := Fboard[x, y].Value;
    Fboard[x, y].Value := 0;
    FisMoved := true;
  end;
  if d > 0 then
  begin
    if y + d < 3 then
    begin
      MoveVertically(x, y + d, 1);
    end;
  end
  else
  begin
    if y + d > 0 then
    begin
      MoveVertically(x, y + d, -1);
    end;
  end;
end;

function TG2048.TestAdd(x, y, value: Integer): boolean;
begin
  if (x < 0) or (x > 3) or (y < 0) or (y > 3) then
    Exit(false);

  Exit(Fboard[x, y].value = value);
end;

procedure TG2048.WaitKey;
var
  y, x: Integer;
begin
  FisMoved := false;
  writeln('(W) Up (S) Down (A) Left (D) Right (ESC)Exit');
  case ReadKey of
    'W', 'w':
      Move(TMoveDirection.mdUp);
    'A', 'a':
      Move(TMoveDirection.mdLeft);
    'S', 's':
      Move(TMoveDirection.mdDown);
    'D', 'd':
      Move(TMoveDirection.mdRight);
    #27:
      FisDone := true;
  end;

  for y := 0 to 3 do
    for x := 0 to 3 do
      Fboard[x, y].IsBlocked := false;
end;

var
  Game: TG2048;
begin
  with TG2048.Create do
  begin
    Loop;
    Free;
  end;
  Writeln('Press Enter to exit');
  Readln;
end.
