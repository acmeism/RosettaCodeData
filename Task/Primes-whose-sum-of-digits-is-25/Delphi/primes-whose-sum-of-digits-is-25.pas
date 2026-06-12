program Primes_which_sum_of_digits_is_25;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  PrimTrial;

var
  row: Integer = 0;
  limit1: Integer = 25;
  limit2: Integer = 5000;

function Sum25(n: Integer): boolean;
var
  sum: Integer;
  str: string;
  c: char;
begin
  sum := 0;
  str := n.ToString;
  for c in str do
    inc(sum, strToInt(c));
  Result := sum = limit1;
end;

begin
  for var n := 1 to limit2-1 do
  begin
    if isPrime(n) and sum25(n) then
    begin
      inc(row);
      write(n: 4, ' ');
      if (row mod 5) = 0 then
        writeln;
    end;
  end;
  readln;
end.
