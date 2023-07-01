program Mertens_function;

{$APPTYPE CONSOLE}

uses
  System.SysUtils;

type
  TMertens = record
    merts: TArray<Integer>;
    zeros, crosses: Integer;
    class function Mertens(_to: Integer): TMertens; static;
  end;

{ TMertens }

class function TMertens.Mertens(_to: Integer): TMertens;
var
  sum, zeros, crosses: Integer;
begin
  if _to < 1 then
    _to := 1;

  sum := 0;
  zeros := 0;
  crosses := 0;

  SetLength(Result.merts, _to + 1);
  var primes := [2];
  for var i := 1 to _to do
  begin
    var j := i;
    var cp := 0;
    var spf := false;
    for var p in primes do
    begin
      if p > j then
        Break;
      if j mod p = 0 then
      begin
        j := j div p;
        inc(cp);
      end;

      if j mod p = 0 then
      begin
        spf := true;
        Break;
      end;
    end;
    if (cp = 0) and (i > 2) then
    begin
      cp := 1;
      SetLength(primes, Length(primes) + 1);
      primes[High(primes)] := i;
    end;

    if not spf then
    begin
      if cp mod 2 = 0 then
        inc(sum)
      else
        dec(sum);
    end;

    Result.merts[i] := sum;
    if sum = 0 then
    begin
      inc(zeros);
      if (i > 1) and (Result.merts[i - 1] <> 0) then
        inc(crosses);
    end;
  end;
  Result.zeros := zeros;
  Result.crosses := crosses;
end;

begin
  var m := TMertens.mertens(1000);
  writeln('Mertens sequence - First 199 terms:');
  for var i := 0 to 199 do
  begin
    if i = 0 then
    begin
      write('    ');
      Continue;
    end;
    if i mod 20 = 0 then
      writeln;
    write(format(' %3d', [m.merts[i]]));
  end;
  writeln(#10#10'Equals zero ', m.zeros, ' times between 1 and 1000');
  writeln(#10'Crosses zero ', m.crosses, ' times between 1 and 1000');
  {$IFNDEF UNIX} readln; {$ENDIF}
end.
