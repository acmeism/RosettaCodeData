program AlmostPrime;
{$IFDEF FPC}
  {$Mode Delphi}
{$ENDIF}
uses
  primtrial;
var
  i,K,cnt : longWord;
BEGIN
  K := 1;
  repeat
    cnt := 0;
    i := 2;
    write('K=',K:2,':');
    repeat
      if isAlmostPrime(i,K) then
      Begin
        write(i:6,' ');
        inc(cnt);
      end;
      inc(i);
    until cnt = 9;
    writeln;
    inc(k);
  until k > 10;
END.
