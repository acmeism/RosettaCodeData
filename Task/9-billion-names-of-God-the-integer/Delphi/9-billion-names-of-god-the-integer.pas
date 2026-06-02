program NamesOfGod;

{
  Rosetta Code: "The Nine Billion Names of God the Integer".

  Builds the partition triangle T[n,k] = number of partitions of n whose
  largest part is exactly k, using the recurrence
      T[n,k] = T[n-1, k-1] + T[n-k, k]
  with T[0,0] = 1 and T[m,0] = 0 for m >= 1.

  Displays the first 25 rows. Computes G(n) (the row sum) via knapsack-style
  DP and P(n) (the integer partition function) via Euler's pentagonal-number
  recurrence, and shows G(n) = P(n) for n in (23, 123, 1234, 12345)

  Values for n >= 1234 don't fit in 64-bit integers, so a minimal arbitrary-
  precision non-negative integer type TBigInt (base 10^9) is included. }

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  System.Math,
  System.Classes,
  System.Diagnostics;

const
  BigBase = 1000000000;  // 10^9 fits in UInt32

// ============================================================================
//  Minimal non-negative big integer, base 10^9, little-endian digit array.
//  Operations are exposed as plain procedures rather than record methods.
// ============================================================================

type
  TBigInt = record
    Digits: TArray<UInt32>;
  end;

procedure BigNormalize(var X: TBigInt);
begin
  while (Length(X.Digits) > 0) and (X.Digits[High(X.Digits)] = 0) do
    SetLength(X.Digits, Length(X.Digits) - 1);
end;

procedure BigSetZero(var X: TBigInt);
begin
  SetLength(X.Digits, 0);
end;

procedure BigSetOne(var X: TBigInt);
begin
  SetLength(X.Digits, 1);
  X.Digits[0] := 1;
end;

function BigEqual(const A, B: TBigInt): Boolean;
var
  I: Integer;
begin
  if Length(A.Digits) <> Length(B.Digits) then
    Exit(False);
  for I := 0 to High(A.Digits) do
    if A.Digits[I] <> B.Digits[I] then
      Exit(False);
  Result := True;
end;

procedure BigAdd(var X: TBigInt; const Y: TBigInt);
var
  I, ALen, BLen, MaxLen: Integer;
  Acc, CarryOut: UInt64;
  ADig, BDig: UInt32;
begin
  ALen := Length(X.Digits);
  BLen := Length(Y.Digits);
  MaxLen := Max(ALen, BLen);
  SetLength(X.Digits, MaxLen + 1);
  CarryOut := 0;
  for I := 0 to MaxLen - 1 do
  begin
    if I < ALen then ADig := X.Digits[I] else ADig := 0;
    if I < BLen then BDig := Y.Digits[I] else BDig := 0;
    Acc := UInt64(ADig) + BDig + CarryOut;
    X.Digits[I] := UInt32(Acc mod BigBase);
    CarryOut := Acc div BigBase;
  end;
  X.Digits[MaxLen] := UInt32(CarryOut);
  BigNormalize(X);
end;

// Assumes X >= Y.
procedure BigSub(var X: TBigInt; const Y: TBigInt);
var
  I, BLen: Integer;
  Borrow, Diff: Int64;
  BDig: UInt32;
begin
  BLen := Length(Y.Digits);
  Borrow := 0;
  for I := 0 to High(X.Digits) do
  begin
    if I < BLen then BDig := Y.Digits[I] else BDig := 0;
    Diff := Int64(X.Digits[I]) - BDig - Borrow;
    if Diff < 0 then
    begin
      Diff := Diff + BigBase;
      Borrow := 1;
    end
    else
      Borrow := 0;
    X.Digits[I] := UInt32(Diff);
  end;
  BigNormalize(X);
end;

function BigToDecimal(const X: TBigInt): string;
var
  I: Integer;
  Sb: TStringBuilder;
begin
  if Length(X.Digits) = 0 then
    Exit('0');
  Sb := TStringBuilder.Create;
  try
    Sb.Append(IntToStr(X.Digits[High(X.Digits)]));
    for I := High(X.Digits) - 1 downto 0 do
      Sb.Append(Format('%.9d', [X.Digits[I]]));
    Result := Sb.ToString;
  finally
    Sb.Free;
  end;
end;

procedure BigAssign(var Dst: TBigInt; const Src: TBigInt);
begin
  Dst.Digits := Copy(Src.Digits);
end;

// ============================================================================
//  Partition triangle (first 25 rows, small values fit in Int64)
// ============================================================================

const
  TriangleRows = 25;

procedure PrintTriangle;
var
  T: array [0 .. TriangleRows, 0 .. TriangleRows] of Int64;
  N, K: Integer;
  RowSum: Int64;
  Sums: array [1 .. TriangleRows] of Int64;
begin
  for N := 0 to TriangleRows do
    for K := 0 to TriangleRows do
      T[N, K] := 0;
  T[0, 0] := 1;
  for N := 1 to TriangleRows do
    for K := 1 to N do
      T[N, K] := T[N - 1, K - 1] + T[N - K, K];

  Writeln('First ', TriangleRows, ' rows of the partition triangle');
  Writeln('T[n,k] = number of partitions of n with largest part = k');
  Writeln('Each row sum equals P(n).');
  Writeln;
  for N := 1 to TriangleRows do
  begin
    Write(StringOfChar(' ', (TriangleRows - N) * 2));
    for K := 1 to N do
      Write(Format('%4d', [T[N, K]]));
    Writeln;
  end;

  for N := 1 to TriangleRows do
  begin
    RowSum := 0;
    for K := 1 to N do
      RowSum := RowSum + T[N, K];
    Sums[N] := RowSum;
  end;

  Writeln;
  Writeln('Row sums  P(1) .. P(', TriangleRows, ')  (5 per line):');
  for N := 1 to TriangleRows do
  begin
    Write(Format('  P(%2d)=%-6d', [N, Sums[N]]));
    if (N mod 5) = 0 then
      Writeln;
  end;
  if (TriangleRows mod 5) <> 0 then
    Writeln;
end;

// ============================================================================
//  G(n) via knapsack-style DP
//
//  Q[m] starts as 1 for m=0, 0 elsewhere.
//  For k = 1..N, update Q[m] += Q[m-k] for m = k..N.
//  After k reaches N, Q[N] = number of partitions of N (= sum of row N of
//  the triangle, by construction).
// ============================================================================

function G(N: Integer): TBigInt;
var
  Q: TArray<TBigInt>;
  K, M: Integer;
begin
  SetLength(Q, N + 1);
  BigSetOne(Q[0]);
  for K := 1 to N do
    for M := K to N do
      BigAdd(Q[M], Q[M - K]);
  BigAssign(Result, Q[N]);
end;

// ============================================================================
//  P(n) via Euler's pentagonal-number recurrence
//
//  P(n) = sum_{k>=1} (-1)^(k+1) [P(n - k(3k-1)/2) + P(n - k(3k+1)/2)]
//
//  Positive and negative contributions are accumulated separately so the
//  non-negative TBigInt never has to hold a negative intermediate value.
// ============================================================================

function PartitionP(N: Integer): TBigInt;
var
  P: TArray<TBigInt>;
  I, K, G1, G2: Integer;
  Pos, Neg: TBigInt;
begin
  SetLength(P, N + 1);
  BigSetOne(P[0]);
  for I := 1 to N do
  begin
    BigSetZero(Pos);
    BigSetZero(Neg);
    K := 1;
    while True do
    begin
      G1 := K * (3 * K - 1) div 2;
      if G1 > I then
        Break;
      G2 := K * (3 * K + 1) div 2;
      if Odd(K) then
      begin
        BigAdd(Pos, P[I - G1]);
        if G2 <= I then
          BigAdd(Pos, P[I - G2]);
      end
      else
      begin
        BigAdd(Neg, P[I - G1]);
        if G2 <= I then
          BigAdd(Neg, P[I - G2]);
      end;
      Inc(K);
    end;
    BigAssign(P[I], Pos);
    BigSub(P[I], Neg);
  end;
  BigAssign(Result, P[N]);
end;

// ============================================================================
//  Main
// ============================================================================

procedure Main;
const
  Targets: array [0 .. 3] of Integer = (23, 123, 1234, 12345);
var
  I: Integer;
  Sw: TStopwatch;
  GVals, PVals: array [0 .. 3] of TBigInt;
  GTimes, PTimes: array [0 .. 3] of Int64;
begin
  PrintTriangle;
  Writeln;

  for I := 0 to High(Targets) do
  begin
    Sw := TStopwatch.StartNew;
    GVals[I] := G(Targets[I]);
    Sw.Stop;
    GTimes[I] := Sw.ElapsedMilliseconds;
  end;

  for I := 0 to High(Targets) do
  begin
    Sw := TStopwatch.StartNew;
    PVals[I] := PartitionP(Targets[I]);
    Sw.Stop;
    PTimes[I] := Sw.ElapsedMilliseconds;
  end;

  Writeln('--- G(n) via knapsack-style DP (= sum of triangle row n) ---');
  for I := 0 to High(Targets) do
    Writeln(Format('  G(%5d) = %s   [%d ms]',
      [Targets[I], BigToDecimal(GVals[I]), GTimes[I]]));
  Writeln;

  Writeln('--- P(n) via Euler''s pentagonal-number recurrence ---');
  for I := 0 to High(Targets) do
    Writeln(Format('  P(%5d) = %s   [%d ms]',
      [Targets[I], BigToDecimal(PVals[I]), PTimes[I]]));
  Writeln;

  Writeln('--- Equality check (G(n) = P(n)) ---');
  for I := 0 to High(Targets) do
    Writeln(Format('  n = %5d  ->  %s',
      [Targets[I], BoolToStr(BigEqual(GVals[I], PVals[I]), True)]));
end;

begin
  try
    Main;
  except
    on E: Exception do
    begin
      Writeln(ErrOutput, 'Fatal: ', E.ClassName, ': ', E.Message);
      ExitCode := 1;
    end;
  end;
end.
