program Tau_function;
{$IFDEF Windows}  {$APPTYPE CONSOLE} {$ENDIF}
  function CountDivisors(n: NativeUint): integer;
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
        divCnt := divCnt+cnt;
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
          divCnt := divCnt+cnt;
        end;
        Inc(p, 2);
      end;
      if n <> 1 then
        divCnt := divCnt+divCnt;
    end;
    CountDivisors := divCnt;
  end;

const
  UPPERLIMIT = 99;
  colWidth = trunc(ln(UPPERLIMIT)/ln(10))+1;
var
  i: NativeUint;
begin
  writeln('The tau functions for the first ',UPPERLIMIT,' positive integers are:');
  Write('': colWidth+1);
  for i := 0 to 9 do
    Write(i: colWidth, ' ');
  for i := 0 to UPPERLIMIT do
  begin
    if i mod 10 = 0 then
    begin
      writeln;
      Write(i div 10: colWidth, '|');
    end;
    Write(CountDivisors(i): colWidth, ' ');
  end;
  writeln;
  {$Ifdef Windows}readln;{$ENDIF}
end.
