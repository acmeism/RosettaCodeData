const
  n = 6666;

var
  p: array of biginteger;
  pd: array of integer;

function PartiDiffDiff(n: Integer): Integer;
begin
  if (n and 1) = 1 then result := ((n + 1) div 2)
  else Result := n + 1;
end;

function partDiff(n: Integer): Integer;
begin
  if n < 2 then result := 1
  else begin
    pd[n] := pd[n - 1] + PartiDiffDiff(n - 1);
    Result := pd[n];
  end;
end;

procedure partitionP(n: Integer);
begin
  if n < 2 then exit;
  var psum := 0bi;
  for var i := 1 to n do
  begin
    var pdi := partDiff(i);
    if pdi > n then Break;
    var sign := -1bi;
    if (i - 1) mod 4 < 2 then sign := 1;
    psum += p[n - pdi] * sign;
  end;
  p[n] := psum;
end;

begin
  SetLength(p, n + 1);
  SetLength(pd, n + 1);
  p[0] := 1bi;
  pd[0] := 1;
  p[1] := 1bi;
  pd[1] := 1;
  for var i := 2 to n do partitionP(i);
  println(p[n]);
  println('Took', milliseconds, 'milliseconds');
end.
