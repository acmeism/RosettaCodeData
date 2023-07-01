program Prime_decomposition;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

function IsPrime(n: UInt64): Boolean;
var
  i: Integer;
begin
  if n <= 1 then
    exit(False);

  i := 2;
  while i < Sqrt(n) do
  begin
    if n mod i = 0 then
      exit(False);
    inc(i);
  end;

  Result := True;
end;

function GetPrimes(n: UInt64): TArray<UInt64>;
var
  i: Integer;
begin
  while n > 1 do
  begin
    i := 1;
    while True do
    begin
      if IsPrime(i) then
      begin
        if n / i = (round(n / i)) then
        begin
          n := n div i;
          SetLength(Result, Length(Result) + 1);
          Result[High(Result)] := i;
          Break;
        end;
      end;
      inc(i);
    end;
  end;
end;

begin
  for var v in GetPrimes(12) do
    write(v, ' ');
  readln;
end.
