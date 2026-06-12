program Find_prime_n_for_that_reversed_n_is_also_prime;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  PrimTrial;

function Reverse(s: string): string;
var
  i: Integer;
begin
  Result := '';
  if Length(s) < 2 then
    exit(s);
  for i := Length(s) downto 1 do
    Result := Result + s[i];
end;

begin
  writeln('working...'#10);
  var row := 0;
  var count := 0;
  var limit := 500;

  for var n := 1 to limit - 1 do
  begin
    if not isPrime(n) then
      Continue;

    var val := n.ToString;
    var valr := reverse(val);
    var nr := valr.ToInteger;

    if not isPrime(nr) then
      Continue;

    write(n: 4);

    inc(row);
    inc(count);
    if row mod 10 = 0 then
      writeln;
  end;
  writeln(#10#10, 'found ', count, ' primes');
  Writeln('done...');
  readln;
end.
