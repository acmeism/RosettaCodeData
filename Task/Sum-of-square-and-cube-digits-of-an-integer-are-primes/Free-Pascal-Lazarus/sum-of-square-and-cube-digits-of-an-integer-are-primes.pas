program SumOfEtc;

  { Sum of square and cube digits of an integer are primes }

var
  N: integer;

  function IsPrime(Num: integer): boolean;
  var
    I: integer;
    FoundFac: boolean;
  begin
    if Num < 2 then
      Result := False
    else if Num = 2 then
      Result := True
    else if Num mod 2 = 0 then
      Result := False
    else
    begin
      I := 3;
      FoundFac := False;
      while (I * I <= Num) and not FoundFac do
      begin
        if Num mod I = 0 then
          FoundFac := True;
        I := I + 2;
      end;
      Result := not FoundFac;
    end;
  end;

  function SumDigits(Num: longint): integer;
  var
    Sum: integer;
  begin
    Sum := 0;
    while Num <> 0 do
    begin
      Sum := Sum + Num mod 10;
      Num := Num div 10;
    end;
    Result := Sum;
  end;

begin
  for N := 0 to 99 do
    if IsPrime(SumDigits(N * N)) and IsPrime(SumDigits(N * N * N)) then
      Write(N, ' ');
  WriteLn;
end.
