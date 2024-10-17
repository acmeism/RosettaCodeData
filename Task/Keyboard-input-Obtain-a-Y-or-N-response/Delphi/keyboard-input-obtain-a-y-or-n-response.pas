program Obtain_a_Y_or_N_response;

{$APPTYPE CONSOLE}

uses
  System.Console;

function GetKey(acepted: string): Char;
var
  key: Char;
begin
  while True do
  begin
    if Console.KeyAvailable then
    begin
      key := UpCase(Console.ReadKey().KeyChar);
      if pos(key, acepted) > 0 then
        exit(key);
    end;
  end;
  Result := #0; // Never Enter condition
end;

begin
  Console.WriteLine('Press Y or N');
  case GetKey('YN') of
    'Y':
      Console.WriteLine('You pressed Yes');
    'N':
      Console.WriteLine('You pressed No');
  else
    Console.WriteLine('We have a error');
  end;
  Readln;
end.
