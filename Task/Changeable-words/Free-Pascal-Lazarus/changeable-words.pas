{$mode ObjFPC}{$H+}
uses
  Classes, SysUtils;

const
  FNAME = 'unixdict.txt';

function OneCharDifference(s1, s2: string): boolean;
var
  i, diffCount: integer;
begin
  diffCount := 0;
  if Length(s1) <> Length(s2) then
    Exit(false);
  for i := 1 to Length(s1) do
  begin
    if s1[i] <> s2[i] then
      Inc(diffCount);
    if diffCount > 1 then
      Exit(false);
  end;
  Result := diffCount = 1;
end;

procedure PurgeList(var list: TStringList);
{ Remove every word that doesn't have at least 12 characters }
var
  i: Integer;
begin
  for i := Pred(list.Count) downto 0 do
    if Length(list[i]) < 12 then
      list.Delete(i);
end;

var
  list: TStringList;
  i, j: Integer;

begin
  list := TStringList.Create;
  try
    list.LoadFromFile(FNAME);
    PurgeList(list);
    for i := 0 to list.Count - 2 do
      for j := i + 1 to list.Count - 1 do
        if OneCharDifference(list[i], list[j]) then
          writeln(list[i]:15, ' <-> ', list[j]);
  finally
    list.Free;
  end;
end.
