type
  TIntArray = array of Integer;

  { TSudokuSolver }

  TSudokuSolver = class
  private
    FGrid: TIntArray;

    function CheckValidity(val: Integer; x: Integer; y: Integer): Boolean;
    function ToString: string; reintroduce;
    function PlaceNumber(pos: Integer): Boolean;
  public
    constructor Create(s: string);

    procedure Solve;
  end;

implementation

uses
  Dialogs;

{ TSudokuSolver }

function TSudokuSolver.CheckValidity(val: Integer; x: Integer; y: Integer
  ): Boolean;
var
  i: Integer;
  j: Integer;
  StartX: Integer;
  StartY: Integer;
begin
  for i := 0 to 8 do
  begin
    if (FGrid[y * 9 + i] = val) or
       (FGrid[i * 9 + x] = val) then
    begin
      Result := False;
      Exit;
    end;
  end;
  StartX := (x div 3) * 3;
  StartY := (y div 3) * 3;
  for i := StartY to Pred(StartY + 3) do
  begin
    for j := StartX to Pred(StartX + 3) do
    begin
      if FGrid[i * 9 + j] = val then
      begin
        Result := False;
        Exit;
      end;
    end;
  end;
  Result := True;
end;

function TSudokuSolver.ToString: string;
var
  sb: string;
  i: Integer;
  j: Integer;
  c: char;
begin
  sb := '';
  for i := 0 to 8 do
  begin
    for j := 0 to 8 do
    begin
      c := (IntToStr(FGrid[i * 9 + j]) + '0')[1];
      sb := sb + c + ' ';
      if (j = 2) or (j = 5) then sb := sb + '| ';
    end;
    sb := sb + #13#10;
    if (i = 2) or (i = 5) then
      sb := sb + '-----+-----+-----' + #13#10;
  end;
  Result := sb;
end;

function TSudokuSolver.PlaceNumber(pos: Integer): Boolean;
var
  n: Integer;
begin
  Result := False;
  if Pos = 81 then
  begin
    Result := True;
    Exit;
  end;
  if FGrid[pos] > 0 then
  begin
    Result := PlaceNumber(Succ(pos));
    Exit;
  end;
  for n := 1 to 9 do
  begin
    if CheckValidity(n, pos mod 9, pos div 9) then
    begin
      FGrid[pos] := n;
      Result := PlaceNumber(Succ(pos));
      if not Result then
        FGrid[pos] := 0;
    end;
  end;
end;

constructor TSudokuSolver.Create(s: string);
var
  lcv: Cardinal;
begin
  SetLength(FGrid, 81);
  for lcv := 0 to Pred(Length(s)) do
    FGrid[lcv] := StrToInt(s[Succ(lcv)]);
end;

procedure TSudokuSolver.Solve;
begin
  if not PlaceNumber(0) then
    ShowMessage('Unsolvable')
  else
    ShowMessage('Solved!');
  end;
end;
