program Untouchable_numbers;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

function SumDivisors(n: Integer): Integer;
begin
  Result := 1;
  var k := 2;
  if not odd(n) then
    k := 1;
  var i := 1 + k;
  while i * i <= n do
  begin
    if (n mod i) = 0 then
    begin
      inc(Result, i);
      var j := n div i;
      if j <> i then
        inc(Result, j);
    end;
    inc(i, k);
  end;
end;

function Sieve(n: Integer): TArray<Boolean>;
begin
  inc(n);
  SetLength(result, n + 1);
  for var i := 6 to n do
  begin
    var sd := SumDivisors(i);
    if sd <= n then
      result[sd] := True;
  end;
end;

function PrimeSieve(limit: Integer): TArray<Boolean>;
begin
  inc(limit);
  SetLength(result, limit);
  Result[0] := True;
  Result[1] := True;

  var p := 3;
  repeat
    var p2 := p * p;
    if p2 >= limit then
      Break;
    var i := p2;
    while i < limit do
    begin

      Result[i] := True;
      inc(i, 2 * p);
    end;

    repeat
      inc(p, 2);
    until not Result[p];

  until (False);

end;

function Commatize(n: Double): string;
var
  fmt: TFormatSettings;
begin
  fmt := TFormatSettings.Create('en-US');
  Result := n.ToString(ffNumber, 64, 0, fmt);
end;

begin
  var limit := 1000000;
  var c := primeSieve(limit);
  var s := sieve(63 * limit);
  var untouchable: TArray<Integer> := [2, 5];
  var n := 6;
  while n <= limit do
  begin
    if not s[n] and c[n - 1] and c[n - 3] then
    begin
      SetLength(untouchable, Length(untouchable) + 1);
      untouchable[High(untouchable)] := n;
    end;
    inc(n, 2);
  end;
  writeln('List of untouchable numbers <= 2,000:');
  var count := 0;
  var i := 0;
  while untouchable[i] <= 2000 do
  begin
    write(commatize(untouchable[i]): 6);
    if ((i + 1) mod 10) = 0 then
      writeln;
    inc(i);
  end;
  writeln(#10#10, commatize(count): 7, ' untouchable numbers were found  <=     2,000');

  var p := 10;
  count := 0;
  for n in untouchable do
  begin
    inc(count);
    if n > p then
    begin
      var cc := commatize(count - 1);
      var cp := commatize(p);
      writeln(cc, ' untouchable numbers were found  <= ', cp);
      p := p * 10;
      if p = limit then
        Break;
    end;
  end;

  var cu := commatize(Length(untouchable));
  var cl := commatize(limit);
  writeln(cu:7, ' untouchable numbers were found  <= ', cl);
  readln;
end.
