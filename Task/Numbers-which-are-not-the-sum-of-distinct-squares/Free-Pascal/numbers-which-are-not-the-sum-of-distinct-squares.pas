program practicalnumbers;
{$IFDEF Windows}  {$APPTYPE CONSOLE} {$ENDIF}
var
  HasSum: array of byte;
function FindLongestContiniuosBlock(startIdx,MaxIdx:NativeInt):NativeInt;
var
  hs0 : pByte;
  l : NativeInt;
begin
  l := 0;
  hs0 := @HasSum[0];
  for startIdx := startIdx to MaxIdx do
  Begin
    IF hs0[startIdx]=0 then
      BREAK;
    inc(l);
  end;
  FindLongestContiniuosBlock := l;
end;

function SumAllSquares(Limit: Uint32):NativeInt;
//mark sum and than shift by next summand == add
var
  hs0, hs1: pByte;
  idx, j, maxlimit, delta,MaxContiniuos,MaxConOffset: NativeInt;
begin
  MaxContiniuos := 0;
  MaxConOffset := 0;
  maxlimit := 0;
  hs0 := @HasSum[0];
  hs0[0] := 1; //has sum of 0*0
  idx := 1;

  writeln('number offset  longest  sum of');
  writeln('                block  squares');
  while idx <= Limit do
  begin
    delta := idx*idx;
    //delta is within the continiuos range than break
    If (MaxContiniuos-MaxConOffset) > delta then
      BREAK;

    //mark oldsum+ delta with  oldsum
    hs1 := @hs0[delta];
    for j := maxlimit downto 0 do
      hs1[j] := hs1[j] or hs0[j];

    maxlimit := maxlimit + delta;

    j := MaxConOffset;
    repeat
      delta := FindLongestContiniuosBlock(j,maxlimit);
      IF delta>MaxContiniuos then
      begin
        MaxContiniuos:= delta;
        MaxConOffset := j;
      end;
      inc(j,delta+1);
    until j > (maxlimit-delta);
    writeln(idx:4,MaxConOffset:7,MaxContiniuos:8,maxlimit:8);
    inc(idx);
  end;
  SumAllSquares:= idx;
end;

var
  limit,
  sumsquare,
  n: NativeInt;
begin
  Limit := 25;
  sumsquare := 0;
  for n := 1 to Limit do
    sumsquare := sumsquare+n*n;
  writeln('sum of square [1..',limit,'] = ',sumsquare) ;
  writeln;

  setlength(HasSum,sumsquare+1);
  n := SumAllSquares(Limit);
  writeln(n);
  for Limit := 1 to n*n do
    if HasSum[Limit]=0 then
      write(Limit,',');
  setlength(HasSum,0);
 {$IFNDEF UNIX}  readln; {$ENDIF}
end.
