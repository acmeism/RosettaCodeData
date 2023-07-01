program Partition_function_P;

{$APPTYPE CONSOLE}

uses
  System.SysUtils,
  Velthuis.BigIntegers,
  System.Diagnostics;

var
  p: TArray<BigInteger>;
  pd: TArray<Integer>;

function PartiDiffDiff(n: Integer): Integer;
begin
  if n and 1 = 1 then
    exit((n + 1) div 2);
  Result := n + 1;
end;

function partDiff(n: Integer): Integer;
begin
  if n < 2 then
    exit(1);

  pd[n] := pd[n - 1] + PartiDiffDiff(n - 1);
  Result := pd[n];
end;

procedure partitionP(n: Integer);
begin
  if n < 2 then
    exit;

  var psum: BigInteger := 0;
  for var i := 1 to n do
  begin
    var pdi := partDiff(i);
    if pdi > n then
      Break;

    var sign: Int64 := -1;

    if (i - 1) mod 4 < 2 then
      sign := 1;

    var t: BigInteger := BigInteger(p[n - pdi]) * BigInteger(sign);
    psum := psum + t;
  end;
  p[n] := psum;
end;

begin
  var stopwatch := TStopwatch.Create;
  const n = 6666;
  SetLength(p, n + 1);
  SetLength(pd, n + 1);
  stopwatch.Start;
  p[0] := 1;
  pd[0] := 1;
  p[1] := 1;
  pd[1] := 1;
  for var i := 2 to n do
    partitionP(i);
  stopwatch.Stop;
  writeln(format('p[%d] = %s', [n, p[n].ToString]));
  writeln('Took ', stopwatch.ElapsedMilliseconds, 'ms');
  Readln;
end.
