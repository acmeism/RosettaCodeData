program Odd_word_problem;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Console,
  System.Character;

function doChar(isOdd: boolean; f: TProc = nil): Boolean;
begin
  var c: char := Console.ReadKey(True).KeyChar;

  if not isOdd then
    Write(c);

  if c.IsLetter then
    exit(doChar(isOdd,
      procedure
      begin
        Write(c);
        if assigned(f) then
          f();
      end));

  if isOdd then
  begin
    if Assigned(f) then
      f();
    write(c);
  end;

  exit(c <> '.');

end;

begin
  var i: boolean := false;
  while doChar(i) do
    i := not i;
  readln;
end.
