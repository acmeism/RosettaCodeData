program BinomialTransforms;
{$mode objfpc}{$H+}

uses
  SysUtils;

type
  Int64Array = array[0..19] of Int64;

const
  facs: array[1..20] of UInt64 = (
    1, 2, 6, 24, 120, 720, 5040, 40320, 362880, 3628800,
    39916800, 479001600, 6227020800, 87178291200, 1307674368000,
    20922789888000, 355687428096000, 6402373705728000, 121645100408832000,
    2432902008176640000
  );

  Seqs: array[0..3] of Int64Array = (
    (1, 1, 2, 5, 14, 42, 132, 429, 1430, 4862, 16796, 58786, 208012, 742900,
    2674440, 9694845, 35357670, 129644790, 477638700, 1767263190),
    (0, 1, 1, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 1, 0, 1, 0),
    (0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233, 377, 610, 987, 1597, 2584, 4181),
    (1, 0, 0, 1, 0, 1, 1, 1, 2, 2, 3, 4, 5, 7, 9, 12, 16, 21, 28, 37)
  );

  Names: array[0..3] of string = (
    'Catalan number sequence:',
    'Prime flip-flop sequence:',
    'Fibonacci number sequence:',
    'Padovan number sequence:'
  );

function Factorial(N: Integer): UInt64;
begin
  if (N > 20) or (N < 2) then
    Exit(1);
  Result := facs[N];
end;

function Binomial(N, K: Integer): UInt64;
begin
  Result := Factorial(N) div (Factorial(N - K) * Factorial(K));
end;

procedure BtForward(var B: Int64Array; const A: Int64Array; C: Integer);
var
  N, K: Integer;
begin
  for N := 0 to C - 1 do
  begin
    B[N] := 0;
    for K := 0 to N do
      B[N] := B[N] + Binomial(N, K) * A[K];
  end;
end;

procedure BtInverse(var A: Int64Array; const B: Int64Array; C: Integer);
var
  N, K, Sign: Integer;
begin
  for N := 0 to C - 1 do
  begin
    A[N] := 0;
    for K := 0 to N do
    begin
      Sign := Ord((N - K) and 1 <> 0) * -2 + 1;
      A[N] := A[N] + Binomial(N, K) * B[K] * Sign;
    end;
  end;
end;

procedure BtSelfInverting(var B: Int64Array; const A: Int64Array; C: Integer);
var
  N, K, Sign: Integer;
begin
  for N := 0 to C - 1 do
  begin
    B[N] := 0;
    for K := 0 to N do
    begin
      Sign := Ord(K and 1 <> 0) * -2 + 1;
      B[N] := B[N] + Binomial(N, K) * A[K] * Sign;
    end;
  end;
end;

function LeastSquareDiff(Limit: UInt32): UInt32;
var
  N: UInt32;
begin
  N := Trunc(Sqrt(Limit)) + 1;
  while (N * N) - ((N - 1) * (N - 1)) <= Limit do
    Inc(N);
  Result := N;
end;

var
  I, J: Integer;
  Fwd, Res: Int64Array;

begin

  for I := 0 to 3 do
  begin
    WriteLn(Names[I]);
    for J := 0 to 19 do
      Write(Seqs[I][J], ' ');
    WriteLn;

    WriteLn('Forward binomial transform:');
    BtForward(Fwd, Seqs[I], 20);
    for J := 0 to 19 do
      Write(Fwd[J], ' ');
    WriteLn;

    WriteLn('Inverse binomial transform:');
    BtInverse(Res, Seqs[I], 20);
    for J := 0 to 19 do
      Write(Res[J], ' ');
    WriteLn;

    WriteLn('Round trip:');
    BtInverse(Res, Fwd, 20);
    for J := 0 to 19 do
      Write(Res[J], ' ');
    WriteLn;

    WriteLn('Self-inverting:');
    BtSelfInverting(Fwd, Seqs[I], 20);
    for J := 0 to 19 do
      Write(Fwd[J], ' ');
    WriteLn;

    WriteLn('Re-inverted:');
    BtSelfInverting(Res, Fwd, 20);
    for J := 0 to 19 do
      Write(Res[J], ' ');

  end;
end.


