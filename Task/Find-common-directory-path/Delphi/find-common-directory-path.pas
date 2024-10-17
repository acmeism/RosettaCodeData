program Find_common_directory_path;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

function FindCommonPath(Separator: Char; Paths: TArray<string>): string;
var
  SeparatedPath: array of TArray<string>;
  minLength, index: Integer;
  isSame: Boolean;
  j, i: Integer;
  cmp: string;
begin
  SetLength(SeparatedPath, length(Paths));
  minLength := MaxInt;
  for i := 0 to High(SeparatedPath) do
  begin
    SeparatedPath[i] := Paths[i].Split([Separator]);
    if minLength > length(SeparatedPath[i]) then
      minLength := length(SeparatedPath[i]);
  end;

  index := -1;

  for i := 0 to minLength - 1 do
  begin
    isSame := True;
    cmp := SeparatedPath[0][i];
    for j := 1 to High(SeparatedPath) do
      if SeparatedPath[j][i] <> cmp then
      begin
        isSame := False;
        Break;
      end;
    if not isSame then
    begin
      index := i - 1;
      Break;
    end;
  end;

  Result := '';
  if index >= 0 then
    for i := 0 to index do
    begin
      Result := Result + SeparatedPath[0][i];
      if i < index then
        Result := Result + Separator;
    end;
end;

begin
  Writeln(FindCommonPath('/', [
    '/home/user1/tmp/coverage/test',
    '/home/user1/tmp/covert/operator',
    '/home/user1/tmp/coven/members']));
  Readln;
end.
