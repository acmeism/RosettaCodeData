program Pritchard_console;

{$APPTYPE CONSOLE}

uses
  Math, SysUtils, Types;

// Function to return an array of all primes <= N
function PritchardSieve( const N : integer) : Types.TIntegerDynArray;
var
  j, j_max, k, len, nrPrimes, p : integer;
  marked : Types.TBooleanDynArray;
  smallPrimes : Types.TIntegerDynArray; // i.e. primes <= sqrt( N)
  spi : integer; // index into array smallPrimes
const
  SP_STEP = 16; // step when extending dynamic array smallPrimes
begin
  // Deal with trivial input
  result := nil;
  if (N <= 1) then exit;

  // Initialize
  SetLength( marked, N + 1); // 0..N for convenience; marked[0] is not used
  marked[1] := true; // no other initialization of "marked" is needed
  len := 1;
  p := 2;
  SetLength( smallPrimes, SP_STEP);
  spi := 0;

  while p*p <= N do begin
    // Roll the wheel
    if len < N then begin
      j_max := Math.Min( p*len, N);
      for j := len + 1 to j_max do marked[j] := marked[j - len];
      len := j_max;
    end;

    // Unmark multiples of p
    for k := len div p downto 1 do
      if marked[k] then marked[p*k] := false;

    // Store the prime p, extending the array if necessary
    if spi = Length( smallPrimes) then
      SetLength( smallPrimes, spi + SP_STEP);
    smallPrimes[spi] := p;
    inc(spi);

    // Find the next prime p
    if p = 2 then p := 3
    else repeat inc(p) until (p > N) or marked[p];
    // Condition p > N is a safety net; should always hit a marked value
    Assert(p <= N);
  end; // while

  // Final roll, if needed. It is not needed if N >= 49. This is because
  //  2 < 3^2, 2*3 < 5^2, 2*3*5 < 7^2, but thereafter 2*3*5*7 > 11^2, etc.
  if len < N then
    for j := len + 1 to N do marked[j] := marked[j - len];

  // Remove 1 and put the small primes back
  marked[1] := false;
  for k := 0 to spi - 1 do marked[smallPrimes[k]] := true;

  // Use the boolean array to return an array of prime integers
  nrPrimes := 0;
  for j := 2 to N do
    if marked[j] then inc( nrPrimes);
  SetLength( result, nrPrimes);
  k := 0;
  for j := 2 to N do
    if marked[j] then begin result[k] := j; inc(k); end;
end;

// Main routine. User types the program name,
// optionally followed by the limit N (defaults to 150)
var
  N, j : integer;
  primes : Types.TIntegerDynArray;
begin
  if ParamCount = 0 then N := 150
                    else N := SysUtils.StrToInt( ParamStr(1));
  primes := PritchardSieve(N);
  WriteLn( 'Number of primes = ', Length(primes));
  for j := 0 to Length(primes) - 1 do begin
    Write( ' ', primes[j]:4);
    if j mod 10 = 9 then WriteLn;
  end;
end.
