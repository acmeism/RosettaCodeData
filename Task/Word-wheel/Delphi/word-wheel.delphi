program Word_wheel;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.Classes;

function IsInvalid(s: string): Boolean;
var
  c: char;
  leters: set of char;
  firstE: Boolean;
begin
  Result := (s.Length < 3) or (s.IndexOf('k') = -1) or (s.Length > 9);
  if not Result then
  begin
    leters := ['d', 'e', 'g', 'k', 'l', 'n', 'o', 'w'];
    firstE := true;
    for c in s do
    begin
      if c in leters then
        if (c = 'e') and (firstE) then
          firstE := false
        else
          Exclude(leters, AnsiChar(c))
      else
        exit(true);
    end;
  end;
end;

var
  dict: TStringList;
  i: Integer;
begin
  dict := TStringList.Create;
  dict.LoadFromFile('unixdict.txt');

  for i := dict.count - 1 downto 0 do
    if IsInvalid(dict[i]) then
      dict.Delete(i);

  Writeln('The following ', dict.Count, ' words are the solutions to the puzzle:');
  Writeln(dict.Text);

  dict.Free;
  readln;
end.
