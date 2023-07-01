program Tau_number;
{$IFDEF Windows}  {$APPTYPE CONSOLE} {$ENDIF}
  function CountDivisors(n: NativeUint): integer;
  //tau function
  var
    q, p, cnt, divcnt: NativeUint;
  begin
    divCnt := 1;
    if n > 1 then
    begin
      cnt := 1;
      while not (Odd(n)) do
      begin
        n := n shr 1;
        divCnt+= cnt;
      end;
      p := 3;
      while p * p <= n do
      begin
        cnt := divCnt;
        q := n div p;
        while q * p = n do
        begin
          n := q;
          q := n div p;
          divCnt+= cnt;
        end;
        Inc(p, 2);
      end;
      if n <> 1 then
        divCnt += divCnt;
    end;
    CountDivisors := divCnt;
  end;

const
  UPPERLIMIT = 100;
var
  cnt,n: NativeUint;
begin
  cnt := 0;
  n := 1;
  repeat
    if n MOD CountDivisors(n) = 0 then
    Begin
      write(n:5);
      inc(cnt);
      if cnt Mod 10 = 0 then
        writeln;
    end;
    inc(n);
  until cnt >= UPPERLIMIT;
  writeln;
  {$Ifdef Windows}readln;{$ENDIF}
end.
