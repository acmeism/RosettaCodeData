program Euler92;
const
  maxdigCnt = 14;
  //2* to use the sum of two square-sums without access violation
  maxPoss = 2* 9*9*maxdigCnt;// every digit is 9
  cM  = 10*1000*1000;// 10^(maxdigCnt div 2)
  IdxSqrSum = cM;//MaxPoss;//max(cM,MaxPoss);
type
  tSqrSum   = array[0..IdxSqrSum] of Word;
  tEndsIn   = array[0..maxPoss]of Byte;
  tresCache = array[0..maxPoss]of Uint64;

var
  aSqrDigSum : tSqrSum;
  aEndsIn: tEndsIn;
  aresCache : tresCache;

procedure CreateSpuareDigitSum;
var
  i,j,k,l : integer;
begin
  For i := 0 to 9 do
    aSqrDigSum[i] := sqr(i);
  k := 10;
  l := k;
  while k < cM do
  begin
    For i := 1 to 9 do
      For j := 0 to k-1 do
      begin
        aSqrDigSum[l]:=aSqrDigSum[i]+aSqrDigSum[j];
        inc(l);
      end;
    k := l;
  end;
  aSqrDigSum[l] := 1;
end;

function InitEndsIn(n:LongWord):longWord;
{fill aEndsIN recursive}
var
  d,s:LongWord;
begin
  IF n in [0..1] then
  begin
    InitEndsIn := n;
    EXIT;
  end;
  s := aSqrDigSum[n];
  {if unknown}
  IF aEndsIN[s] = byte(-1) then
  begin
    d := InitEndsIn(s);
    aEndsIN[s]:= d;
    InitEndsIn := d;
  end
  else
    InitEndsIn := aEndsIN[s];
end;

function CntSmallOnes(s:longWord;
                      n:longWord=cM-1):NativeUint;
var
  i: longword;
begin
  result := 0;
  For i := cM-1 downto 0 do
    result := result+aEndsIN[aSqrDigSum[i]+s];
end;

procedure Init;
var
  i,j,cnt : integer;
begin
  CreateSpuareDigitSum;
  fillchar(aEndsIN,Sizeof(aEndsIN) ,#255);
  aEndsIN[0] := 0;
  aEndsIN[1]:= 1;
  aEndsIN[89]:= 0;// no need to use 89
  For i := 1 to maxPoss do
    aEndsIN[i]:= InitEndsIN(i);

  cnt := 0;
  fillchar(aresCache,SizeOf(aresCache),#0);
  For i := Low(tSqrSum) to high(tSqrSum) do
  begin
    j := aSqrDigSum[i];
    If aresCache[j] = 0 then
    begin
//      write(i,',');
      aresCache[j] := CntSmallOnes(j);
      inc(cnt);
    end;
  end;
//  writeln;  writeln(cnt,' small counts out of ',cM);
end;
{
function EndsIn(n:LongWord):Word;
var
  d,s:LongWord;
begin
  d := n;
  s := 0;
  while d > High(tSqrSum) do
  begin
    s := s+aSqrDigSum[d Mod cM];
    d := d Div cM
  end;
  s :=s+aSqrDigSum[d];
  EndsIn := aEndsIN[s];
end;
}

function CntOnes(s: longWord;n:Int64):Int64;
var
  i : Int64;
begin
writeln;
  result := 0;
  i := n div cM;
  repeat
    result := result+aresCache[s+aSqrDigSum[i]];
    dec(i)
  until i < 0
end;

const
  upperlimit = cM*cM ;
var
  Res : Int64;
begin
  Init;
  Res := CntOnes(0,upperlimit-1)+1;
  writeln('there are ',res,'  1s ');
  writeln('there are ',upperlimit-res,' 89s ');
end.
