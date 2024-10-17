program Optional_parameters;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

type
  TRow = TArray<string>;

  TOrderingFun = TFunc<TRow, TRow, Boolean>;

  TTable = array of TRow;

  TRowHelper = record helper for TRow
  public
    procedure Swap(var other: TRow);
    function ToString: string;
    function Length: Integer;
  end;

  TTableHelper = record helper for TTable
  private
    procedure ExchangeRow(i, j: Integer);
  public
    procedure Sort(OrderingFun: TOrderingFun);
    procedure Reverse;
    function ToString: string;
  end;

function Max(a, b: Integer): Integer;
begin
  if a > b then
    exit(a);
  Result := b;
end;

{ TRowHelper }

function TRowHelper.Length: Integer;
begin
  Result := System.Length(self);
end;

procedure TRowHelper.Swap(var other: TRow);
var
  aLengthOther, aLengthSelf, aLength: Integer;
  tmp: string;
  i: Integer;
begin
  aLengthOther := other.Length;
  aLengthSelf := self.Length;
  aLength := max(aLengthOther, aLengthSelf);
  if aLength = 0 then
    exit;

  SetLength(self, aLength);
  SetLength(other, aLength);

  for i := 0 to aLength - 1 do
  begin
    tmp := self[i];
    self[i] := other[i];
    other[i] := tmp;
  end;

  SetLength(self, aLengthOther);
  SetLength(other, aLengthSelf);
end;

function TRowHelper.ToString: string;
var
  i: Integer;
begin
  Result := '[';
  for i := 0 to High(self) do
  begin
    if i > 0 then
      Result := Result + ', ';
    Result := Result + '"' + self[i] + '"';
  end;
  Result := Result + ']';
end;

{ TTableHelper }

procedure TTableHelper.ExchangeRow(i, j: Integer);
begin
  Self[i].Swap(self[j]);
end;

procedure TTableHelper.reverse;
var
  aLength, aHalfLength: Integer;
  i: Integer;
begin
  aLength := Length(self);
  aHalfLength := aLength div 2;
  for i := 0 to aHalfLength - 1 do
    ExchangeRow(i, aLength - i - 1);
end;

procedure TTableHelper.Sort(OrderingFun: TOrderingFun);
var
  i, j, aLength: Integer;
begin
  if not Assigned(OrderingFun) then
    exit;

  aLength := Length(self);
  for i := 0 to aLength - 2 do
    for j := i + 1 to aLength - 1 do
      if OrderingFun(self[i], self[j]) then
        ExchangeRow(i, j);
end;

function TTableHelper.ToString: string;
var
  i: Integer;
begin
  Result := '[';
  for i := 0 to High(self) do
  begin
    if i > 0 then
      Result := Result + #10;
    Result := Result + self[i].ToString;
  end;
  Result := Result + ']';
end;

function SortTable(table: TTable; Ordering: TOrderingFun = nil; column: Integer
  = 0; reverse: Boolean = false): TTable;
var
  acolumn: Integer;
begin
  acolumn := column;
  if not Assigned(Ordering) then
    Ordering :=
      function(left, right: TRow): Boolean
      begin
        Result := left[acolumn] > right[acolumn];
      end;

  table.Sort(Ordering);
  if (reverse) then
    table.reverse();
  Result := table;
end;

var
  data: TTable = [['a', 'b', 'c'], ['', 'q', 'z'], ['zap', 'zip', 'Zot']];

begin
  Writeln(data.ToString, #10);
  Writeln(SortTable(data).ToString, #10);
  Writeln(SortTable(data).ToString, #10);
  Writeln(SortTable(data, nil, 2).ToString, #10);
  Writeln(SortTable(data, nil, 1).ToString, #10);
  Writeln(SortTable(data, nil, 1, True).ToString, #10);
  Writeln(SortTable(data,
    function(left, right: TRow): Boolean
    begin
      Result := left.Length > right.Length;
    end).ToString, #10);
  Readln;
end.
