program PrimeRng;
uses
  primTrial;
var
  Range : ptPrimeList;
  i : integer;
Begin
  Range := PrimeRange(1000*1000*1000,1000*1000*1000+100);
  For i := Low(Range) to High(Range) do
    write(Range[i]:12);
  writeln;
end.
