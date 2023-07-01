Program Example40;
{$IFDEF FPC}
  {$MOde objFPC}
{$ENDIF}
{ Program to demonstrate the randg function. }
Uses Math;

type
  tTestData =  extended;//because of math.randg
  ttstfunc = function  (mean, sd: tTestData): tTestData;
  tExArray = Array of tTestData;
  tSolution = record
                SolExArr : tExArray;
                SollowVal,
                SolHighVal,
                SolMean,
                SolStdDiv : tTestData;
                SolSmpCnt : LongInt;
              end;

function getSol(genFunc:ttstfunc;Mean,StdDiv: tTestData;smpCnt: LongInt): tSolution;
var
  GenValue,
  sumValue,
  sumsqrVal : extended;
Begin
  with result do
  Begin
    SolSmpCnt  := smpCnt;
    SolMean    := 0;
    SolStdDiv  := 0;
    SolLowVal  := Mean+50* StdDiv;
    SolHighVal := Mean-50* StdDiv;
    setlength(SolExArr,smpCnt);
    if smpCnt <= 0 then
      EXIT;
    sumValue   := 0;
    sumsqrVal  := 0;
    repeat
      GenValue   := genFunc(Mean,StdDiv);
      sumValue   := sumvalue+GenValue;
      sumsqrVal  :=  sumsqrVal+sqr(GenValue);
      IF GenValue < SollowVal then
        SollowVal:= GenValue
      else
        IF GenValue > SolHighVal then
           SolHighVal := GenValue;
      dec(smpCnt);
      SolExArr[smpCnt] := GenValue;
    until smpCnt<= 0;
    SolMean := sumValue/SolSmpCnt;
    SolStdDiv := sqrt(sumsqrVal/SolSmpCnt-sqr(SolMean));
  end;
end;

//http://wiki.freepascal.org/Generating_Random_Numbers#Normal_.28Gaussian.29_Distribution
function rnorm (mean, sd: tTestData): tTestData;
 {Calculates Gaussian random numbers according to the Box-Müller approach}
  var
   u1, u2: extended;
 begin
   u1 := random;
   u2 := random;
   rnorm := mean * abs(1 + sqrt(-2 * (ln(u1))) * cos(2 * pi * u2) * sd);
  end;

procedure Histo(const sol:TSolution;Colcnt,ColLen :LongInt);
var
  CntHisto : array of integer;
  LoLmt,HiLmt,span : tTestData;
  i, j,cnt,maxCnt: LongInt;
  sCross : Ansistring;
Begin
  setlength(CntHisto,Colcnt);
  with Sol do
  Begin
    span := solHighVal-solLowVal;
    LoLmt := solLowVal;
    writeln('Count: ',SolSmpCnt:10,' Mean ',SolMean:10:6,' StdDiv ',SolStdDIv:10:6);
    writeln('span : ',span:10:5,' Low  ',solLowVal:10:6,'   high ',solHighVal:10:6);

  end;
  maxCnt := 0;
  For j := 0 to Colcnt-1 do
  Begin
    HiLmt:= LoLmt+span/Colcnt;
    cnt := 0;
    with sol do
      For i := 0 to High(SolExArr) do
         IF (HiLmt > SolExArr[i]) AND  (SolExArr[i]>= LoLmt) then
            inc(cnt);
    CntHisto[j] := cnt;
    IF maxCnt < cnt then
      maxCnt := cnt;
    LoLmt:=  HiLmt;
  end;
  inc(CntHisto[Colcnt]); // for HiLmt itself
  writeln;
  LoLmt := sol.solLowVal;
  For i := 0 to Colcnt-1 do
  Begin
    Writeln(LoLmt:8:4,': ');
    cnt:= Round(CntHisto[i]*ColLen/maxCnt);
    setlength(sCross,cnt+3);
    fillChar(sCross[1],3,' ');
    fillChar(sCross[4],cnt,'#');
    writeln(CntHisto[i]:10,sCross);
    LoLmt := LoLmt+span/Colcnt;
  end;
  Writeln(sol.solHighVal:8:4,': ');
end;

const
  cHistCnt = 11;
  cColLen = 65;

  cStdDiv = 0.25;
  cMean   = 20*cStdDiv;
var
  mySol : tSolution;
begin
  Randomize;
  // test of randg of unit math
  Writeln('function randg');
  mySol := getSol(@randg,cMean,cMean*cStdDiv,100000);
  Histo(mySol,cHistCnt,cColLen);
  writeln;
  // test of rnorm from wiki
  Writeln('function rnorm');
  mySol := getSol(@rnorm,cMean,cStdDiv,1000000);
  Histo(mySol,cHistCnt,cColLen);
end.
