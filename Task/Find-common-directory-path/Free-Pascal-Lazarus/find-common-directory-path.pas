Program CommonPaths;
{$mode ObjFPC}{$H+}
uses
  Classes, Math;

const
  Paths: array of string = ('/home/user1/tmp/coverage/test',
                            '/home/user1/tmp/covert/operator',
                            '/home/user1/tmp/coven/members');

function FindShortestCommonPath(arr: array of TStringList; shortestPath: Integer): string;
var
  i, j: Integer;
  commonStr: string;
begin
  Result := '/';
  if Length(arr) = 0 then
    Exit;
  for j := 0 to shortestPath - 1 do
  begin
    commonStr := arr[0][j];
    for i := 1 to High(arr) do
    begin
      if arr[i][j] <> commonStr then
        Exit(Result);
    end;
    Result := Result + commonStr + '/';
  end;
end;
var
  arr: array of TStringList;
  i, shortestpath: uint32;

begin
  shortestpath := High(uint32);
  SetLength(arr, Length(paths));

  for i := 0 to High(paths) do
  begin
    arr[i] := TStringList.Create;
    arr[i].AddDelimitedText(paths[i], '/', false);
    arr[i].Delete(0);
    shortestpath := Min(shortestpath, arr[i].Count);
  end;

  Writeln(FindShortestCommonPath(arr, shortestpath));

  for i := 0 to High(paths) do
    arr[i].Free;
end.
