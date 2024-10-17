program Comb_sort;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Types;

type
  THelperIntegerDynArray = record helper for TIntegerDynArray
  public
    procedure CombSort;
    procedure FillRange(Count: integer);
    procedure Shuffle;
    function ToString: string;
  end;

{ THelperIntegerDynArray }
procedure THelperIntegerDynArray.CombSort;
var
  i, gap, temp: integer;
  swapped: boolean;
begin
  gap := length(self);
  swapped := true;
  while (gap > 1) or swapped do
  begin
    gap := trunc(gap / 1.3);
    if (gap < 1) then
      gap := 1;
    swapped := false;
    for i := 0 to length(self) - gap - 1 do
      if self[i] > self[i + gap] then
      begin
        temp := self[i];
        self[i] := self[i + gap];
        self[i + gap] := temp;
        swapped := true;
      end;
  end;
end;

procedure THelperIntegerDynArray.FillRange(Count: integer);
var
  i: Integer;
begin
  SetLength(self, Count);
  for i := 0 to Count - 1 do
    Self[i] := i;
end;

procedure THelperIntegerDynArray.Shuffle;
var
  i, j, tmp: integer;
  count: integer;
begin
  Randomize;
  count := Length(self);
  for i := 0 to count - 1 do
  begin
    j := i + Random(count - i);
    tmp := self[i];
    self[i] := self[j];
    self[j] := tmp;
  end;
end;

function THelperIntegerDynArray.ToString: string;
var
  value: Integer;
begin
  Result := '';
  for value in self do
  begin
    Result := Result + ' ' + Format('%4d', [value]);
  end;
  Result := '[' + Result.Trim + ']';
end;

var
  data: TIntegerDynArray;

begin
  data.FillRange(10);
  data.Shuffle;
  writeln('The data before sorting:');
  Writeln(data.ToString, #10);

  data.CombSort;

  writeln('The data after sorting:');
  Writeln(data.ToString, #10);

  Readln;
end.
