program Loop;

{$APPTYPE CONSOLE}

var
  I: Integer;

begin
  I:= 0;
  repeat
    Inc(I);
    Write(I:2);
  until I mod 6 = 0;
  Writeln;
  Readln;
end.
