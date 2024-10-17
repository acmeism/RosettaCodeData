(* Compiled with Delphi XE *)
program UnicodeVariableName;

{$APPTYPE CONSOLE}

uses
  SysUtils;

var
  Δ: Integer;

begin
  Δ:= 1;
  Inc(Δ);
  Writeln(Δ);
  Readln;
end.
