program Two_Sum;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Generics.Collections;

function TwoSum(arr: TArray<Integer>; num: Integer; var i, j: integer): boolean;
begin
  TArray.Sort<Integer>(arr);
  i := 0;
  j := Length(arr) - 1;
  while i < j do
  begin
    if arr[i] + arr[j] = num then
      exit(True);

    if arr[i] + arr[j] < num then
      inc(i)
    else
      Dec(j);
  end;
  Result := false;
end;

var
  i, j: Integer;

begin
  if TwoSum([0, 2, 11, 19, 90], 21, i, j) then
    Writeln('(', i, ',', j, ')');

  if TwoSum([0, 2, 11, 19, 90], 25, i, j) then
    Writeln('(', i, ',', j, ')');
  Readln;
end.
