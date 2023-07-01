program ProperDivisors;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.Generics.Collections;

type
  TProperDivisors = TArray<Integer>;

function GetProperDivisors(const value: Integer): TProperDivisors;
var
  i, count: Integer;
begin
  count := 0;

  for i := 1 to value div 2 do
  begin
    if value mod i = 0 then
    begin
      inc(count);
      SetLength(result, count);
      Result[count - 1] := i;
    end;
  end;
end;

procedure Println(values: TProperDivisors);
var
  i: Integer;
begin
  Write('[');
  if Length(values) > 0 then
    for i := 0 to High(values) do
      Write(Format('%2d', [values[i]]));
  Writeln(']');
end;

var
  number, max_count, count, max_number: Integer;

begin
  for number := 1 to 10 do
  begin
    write(number, ': ');
    Println(GetProperDivisors(number));
  end;

  max_count := 0;
  for number := 1 to 20000 do
  begin
    count := length(GetProperDivisors(number));
    if count > max_count then
    begin
      max_count := count;
      max_number := number;
    end;
  end;

  Write(max_number, ': ', max_count);

  readln;
end.
