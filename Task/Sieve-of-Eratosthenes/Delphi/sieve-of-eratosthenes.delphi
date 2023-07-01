program erathostenes;

{$APPTYPE CONSOLE}

type
  TSieve = class
  private
    fPrimes: TArray<boolean>;
    procedure InitArray;
    procedure Sieve;
    function getNextPrime(aStart: integer): integer;
    function getPrimeArray: TArray<integer>;
  public
    function getPrimes(aMax: integer): TArray<integer>;
  end;

  { TSieve }

function TSieve.getNextPrime(aStart: integer): integer;
begin
  result := aStart;
  while not fPrimes[result] do
    inc(result);
end;

function TSieve.getPrimeArray: TArray<integer>;
var
  i, n: integer;
begin
  n := 0;
  setlength(result, length(fPrimes)); // init array with maximum elements
  for i := 2 to high(fPrimes) do
  begin
    if fPrimes[i] then
    begin
      result[n] := i;
      inc(n);
    end;
  end;
  setlength(result, n); // reduce array to actual elements
end;

function TSieve.getPrimes(aMax: integer): TArray<integer>;
begin
  setlength(fPrimes, aMax);
  InitArray;
  Sieve;
  result := getPrimeArray;
end;

procedure TSieve.InitArray;
begin
  for i := 2 to high(fPrimes) do
    fPrimes[i] := true;
end;

procedure TSieve.Sieve;
var
  i, n, max: integer;
begin
  max := length(fPrimes);
  i := 2;
  while i < sqrt(max) do
  begin
    n := sqr(i);
    while n < max do
    begin
      fPrimes[n] := false;
      inc(n, i);
    end;
    i := getNextPrime(i + 1);
  end;
end;

var
  i: integer;
  Sieve: TSieve;

begin
  Sieve := TSieve.Create;
  for i in Sieve.getPrimes(100) do
    write(i, ' ');
  Sieve.Free;
  readln;
end.
