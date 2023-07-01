program OctalCount;

{$mode objfpc}{$H+}

var
  i : integer;

// display n in octal on console
procedure PutOctal(n : integer);
var
  digit, n3 : integer;
begin
  n3 := n shr 3;
  if n3 <> 0 then PutOctal(n3);
  digit := n and 7;
  write(digit);
end;

// count in octal until integer overflow
begin
  i := 1;
  while i > 0 do
    begin
       PutOctal(i);
       writeln;
       i := i + 1;
    end;
  readln;
end.
