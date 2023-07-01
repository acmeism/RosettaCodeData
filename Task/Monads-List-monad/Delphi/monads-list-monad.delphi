program List_monad;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

type
  TmList = record
    Value: TArray<Integer>;
    function ToString: string;
    function Bind(f: TFunc<TArray<Integer>, TmList>): TmList;
  end;

function Create(aValue: TArray<Integer>): TmList;
begin
  Result.Value := copy(aValue, 0, length(aValue));
end;

{ TmList }

function TmList.Bind(f: TFunc<TArray<Integer>, TmList>): TmList;
begin
  Result := f(self.Value);
end;

function TmList.ToString: string;
var
  i: Integer;
begin
  Result := '[ ';
  for i := 0 to length(value) - 1 do
  begin
    if i > 0 then
      Result := Result + ', ';
    Result := Result + value[i].toString;
  end;
  Result := Result + ']';
end;

function Increment(aValue: TArray<Integer>): TmList;
var
  i: integer;
begin
  SetLength(Result.Value, length(aValue));
  for i := 0 to High(aValue) do
    Result.Value[i] := aValue[i] + 1;
end;

function Double(aValue: TArray<Integer>): TmList;
var
  i: integer;
begin
  SetLength(Result.Value, length(aValue));
  for i := 0 to High(aValue) do
    Result.Value[i] := aValue[i] * 2;
end;

var
  ml1, ml2: TmList;

begin
  ml1 := Create([3, 4, 5]);
  ml2 := ml1.Bind(Increment).Bind(double);
  Writeln(ml1.ToString, ' -> ', ml2.ToString);
  readln;
end.
