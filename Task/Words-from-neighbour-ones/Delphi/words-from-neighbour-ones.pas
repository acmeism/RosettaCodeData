program Words_from_neighbour_ones;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Classes;

function GetWords(minLength: Integer = 1): TStringList;
var
  i: Integer;
begin
  Result := TStringList.create;
  Result.LoadFromFile('Unixdict.txt');
  with Result do
    for i := Count - 1 downto 0 do
      if Strings[i].Length < minLength then
        Delete(i);
  Result.Sort;
end;

var
  Words: TStringList;

const
  minLength = 9;

begin
  Words := GetWords(minLength);
  var previousWord := '';
  var count := 0;
  var n := Words.Count;

  for var i := 0 to n - minLength do
  begin

    var W := '';
    for var j := 0 to minLength - 1 do
      W := W + Words[i + j][j + 1];
    if W.Equals(previousWord) then
      Continue;
    if Words.IndexOf(W) >= 0 then
    begin
      inc(count);
      writeln(count: 2, '. ', W);
    end;
    previousWord := W;
  end;

  Words.Free;
  readln;
end.
