program MD5Hash;

{$APPTYPE CONSOLE}

uses
  SysUtils,
  IdHashMessageDigest;

function MD5(aValue: string): string;
begin
  with TIdHashMessageDigest5.Create do
  begin
    Result:= HashStringAsHex(aValue);
    Free;
  end;
end;

begin
  Writeln(MD5(''));
  Writeln(MD5('a'));
  Writeln(MD5('abc'));
  Writeln(MD5('message digest'));
  Writeln(MD5('abcdefghijklmnopqrstuvwxyz'));
  Writeln(MD5('ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789'));
  Writeln(MD5('12345678901234567890123456789012345678901234567890123456789012345678901234567890'));
  Readln;
end.
