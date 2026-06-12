program Strange_primes;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

function IsPrime(n: Integer): Boolean;
begin
  if n < 2 then
    exit(false);

  if n mod 2 = 0 then
    exit(n = 2);

  if n mod 3 = 0 then
    exit(n = 3);

  var d := 5;
  while d * d <= n do
  begin
    if n mod d = 0 then
      exit(false);

    inc(d, 2);

    if n mod d = 0 then
      exit(false);

    inc(d, 4);
  end;
  Result := true;
end;

function Commatize(value: Integer): string;
begin
  Result := FloatToStrF(value, ffNumber, 10, 0);
end;

function StrangePrimes(n: Integer; countOnly: Boolean): Integer;
begin
  var c := 0;
  var f := '%2d: %2d + %2d + %2d = %2d'#10;
  var s: Integer := 0;

  var i := 3;
  while i <= n - 4 do
  begin
    if IsPrime(i) then
    begin
      var j := i + 2;
      while j <= n - 2 do
      begin
        if IsPrime(j) then
        begin
          var k := j + 2;
          while k <= n do
          begin
            if IsPrime(k) then
            begin
              s := i + j + k;
              if IsPrime(s) then
              begin
                inc(c);
                if not countOnly then
                  write(format(f, [c, i, j, k, s]));
              end;
            end;
            inc(k, 2);
          end;
        end;
        inc(j, 2);
      end;
    end;
    inc(i, 2);
  end;
  Result := c;
end;

begin
  Writeln('Unique prime triples under 30 which sum to a prime:');
  strangePrimes(29, false);
  var cs := commatize(strangePrimes(999, true));
  writeln('There are ', cs, ' unique prime triples under 1,000 which sum to a prime.');
  readln;
end.
