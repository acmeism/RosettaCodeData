program factors;
{Looking for extreme composite numbers:
http://wwwhomes.uni-bielefeld.de/achim/highly.txt}

const
  MAXFACTORCNT = 1920; //number := 3491888400;

var
  FaktorList : array[0..MAXFACTORCNT] of LongWord;
  i, number,quot,cnt: LongWord;
begin
  writeln('Enter a number between 1 and 4294967295: ');
  write('3491888400 is a nice choice ');
  readln(number);

  cnt := 0;
  i := 1;
  repeat
    quot := number div i;
    if quot *i-number = 0 then
    begin
      FaktorList[cnt] := i;
      FaktorList[MAXFACTORCNT-cnt] := quot;
      inc(cnt);
    end;
    inc(i);
  until i> quot;
  writeln(number,' has ',2*cnt,' factors');
  dec(cnt);
  For i := 0 to cnt do
    write(FaktorList[i],' ,');
  For i := cnt downto 1 do
    write(FaktorList[MAXFACTORCNT-i],' ,');
{ the last without ','}
  writeln(FaktorList[MAXFACTORCNT]);
end.
