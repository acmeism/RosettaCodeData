program FizzBuzz;

{$APPTYPE CONSOLE}

uses SysUtils;

var
  i: Integer;
begin
  for i := 1 to 100 do
  begin
    if i mod 15 = 0 then
      Writeln('FizzBuzz')
    else if i mod 3 = 0 then
      Writeln('Fizz')
    else if i mod 5 = 0 then
      Writeln('Buzz')
    else
      Writeln(i);
  end;
end.
