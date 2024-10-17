program Pierpont_primes;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Math,
  System.StrUtils,
  System.Generics.Collections,
  System.Generics.Defaults,
  Velthuis.BigIntegers,
  Velthuis.BigIntegers.Primes;

function Pierpont(ulim, vlim: Integer; first: boolean): TArray<BigInteger>;
begin
  var p: BigInteger := 0;
  var p2: BigInteger := 1;
  var p3: BigInteger := 1;

  for var v := 0 to vlim - 1 do
  begin
    for var u := 0 to ulim - 1 do
    begin
      p := p2 * p3;
      if first then
        p := p + 1
      else
        p := p - 1;
      if IsProbablePrime(p, 10) then
      begin
        SetLength(result, Length(result) + 1);
        result[High(result)] := BigInteger(p);
      end;
      p2 := p2 * 2;
    end;
    p3 := p3 * 3;
    p2 := 1;
  end;

  TArray.sort<BigInteger>(Result, TComparer<BigInteger>.Construct(
    function(const Left, Right: BigInteger): Integer
    begin
      Result := BigInteger.Compare(Left, Right);
    end));
end;

begin

  writeln('First 50 Pierpont primes of the first kind:');
  var pp := Pierpont(120, 80, True);
  for var i := 0 to 49 do
  begin
    write(pp[i].ToString: 8, ' ');
    if ((i - 9) mod 10) = 0 then
      writeln;
  end;

  writeln('First 50 Pierpont primes of the second kind:');
  var pp2 := Pierpont(120, 80, False);
  for var i := 0 to 49 do
  begin
    write(pp2[i].ToString: 8, ' ');
    if ((i - 9) mod 10) = 0 then
      writeln;
  end;

  Writeln('250th Pierpont prime of the first kind:', pp[249].ToString);
  Writeln('250th Pierpont prime of the second  kind:', pp2[249].ToString);

  readln;
end.
