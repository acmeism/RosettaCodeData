program Project1;

{$APPTYPE CONSOLE}

uses
  SysUtils;
var
  aChar:Char;
  aCode:Byte;
  uChar:WideChar;
  uCode:Word;
begin
  aChar := Chr(97);       Writeln(aChar);
  aCode := Ord(aChar);    Writeln(aCode);
  uChar := WideChar(97);  Writeln(uChar);
  uCode := Ord(uChar);    Writeln(uCode);

  Readln;
end.
