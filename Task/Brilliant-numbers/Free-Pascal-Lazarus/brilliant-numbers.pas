program BrilliantNumbers;
{$IFDEF FPC}
  {$MODE Delphi}
  {$Optimization ON,All}
  {$codealign proc=32,loop=1}
{$ENDIF}
{$IFDEF WINDOWS}
  {$APPTYPE CONSOLE}
{$ENDIF}
uses
  SysUtils,primSieve,classes;
const
  MaxRoot =1000*1000*1000;
type
  tPrime = array of Uint32;
  tpPrime = pUint32;
  tBrilliant = record
                 Count_dgt : Uint64;
                 MinIdx,
                 MidIdx,
                 MaxIdx : Uint32;
               end;
var
{$ALIGN 32}
  BrilliantPos :array [0..10] of TBrilliant;

  function commatize(n:NativeUint):string;
  var
    l,i : NativeUint;
  begin
    str(n,result);
    l := length(result);
    if l < 4 then
      exit;
    i := l+ (l-1) DIV 3;
    setlength(result,i);
    While i <> l do
    Begin
      result[i]:= result[l];
      result[i-1]:= result[l-1];
      result[i-2]:= result[l-2];
      result[i-3]:= ',';
      dec(i,4);
      dec(l,3);
    end;
  end;

  procedure Sieve(var pr: tPrime;n:UInt32);
  //get primes plus one beyond limit
  var
    pPr : pUInt32;
    i,p : Int32;
  begin
    If n> 60184 then
    //Pierre Dusart proved in 2010
      setlength(pr,trunc(n/(ln(n)-1.1)))
    else
      setlength(pr,6542);
    i := 0;
    pPr := @pr[0];
    repeat
      p := NextPrime;
      pPr[i] := p;
      i +=1;
    until p > n;
    setlength(pr,i);
    writeln('Primes [',pPr[0],'..',commatize(pPr[i-2]),'] +',commatize(pPr[i-1]));
  end;

   function InsRes(p : tpPrime;Val,MaxIdx,cnt: Int32):int32;
   var
     i : Int32;
   begin
     if cnt = maxIdx then
     begin
       while (maxIdx >=0) AND (val < p[maxIdx]) do
       Begin
         p[maxIdx+1] := p[maxIdx];
         dec(maxIdx);
       end;
       p[maxIdx+1] := val;
       EXIT(cnt);
     end
     else
     Begin
       i := MaxIDx;
       if val > p[i] then
       begin
         p[i+1] := val;
       end
       else
       begin
         while (i >=0) AND (val < p[i]) do
         Begin
           p[i+1] := p[i];
           dec(i);
         end;
         p[i+1] := val;
       end;
     end;
     result := MaxIdx+1;
     if result > cnt then
       result := cnt;
   end;

   procedure Get_N_Brilliant(pPr:tpPrime;cnt:Int32);
   var
     p_p : array of Int32;
     lmt,p1,p2,i1,i2,maxIdx : Int32;
   Begin
     setlength(p_p,cnt+2);
     MaxIdx := 0;
     p_p[MaxIdx] := maxint;
     i1 := 1;
     p1 := pPr[0];
     lmt := 10;
     repeat
       repeat
         p2 := p1;
         if MaxIdx = cnt then
           if p1*p1 > p_p[MaxIdx] then
             break;
         i2 := i1;
         repeat
           MaxIdx := InsRes(@p_p[0],p1*p2,MaxIdx,cnt);
           p2 := pPr[i2];
           i2+=1;
           if MaxIdx = cnt then
             if p1*p2 > p_p[MaxIdx] then
               break;
         until p2>lmt;
         p1 := pPr[i1];
         i1 +=1;
       until p1>lmt;
       lmt *=10;
     until (MaxIdx = cnt)AND (p1*p1 > p_p[MaxIdx]);

     Writeln('The first ',cnt,' brilliant numbers ');
     For i1 := 1 to cnt do
     Begin
       write(commatize(p_p[i1-1]):6);
         if i1 MOD 10 = 0 then
           write(#13#10);
     end;
     writeln;
  end;

  function BinSearch(pPr:tpPrime;maxIdx,p:NativeUint):NativeInt;
  // binary search for idx , so, that primes[idx-1] < p < primes[idx]
  var
    tmp : double;
    i1,i2,m : nativeUInt;
  begin
   //assumption, where to find the right prime
   tmp := ln(p)-1;
   i1 := trunc(p/tmp);
   i2 := trunc(p/(tmp-0.1));
   IF i2 > MaxIdx then
     i2 := MaxIdx;
   repeat
     m := (i1+i2) shr 1;
     if pPr[m]<p then
       i1 := m+1
     else
       i2 := m-1;
   until i2<i1;
   IF i2 > MaxIdx then
     i2 := MaxIdx;
   while pPr[i2] < p do
     inc(i2);
   result := i2;
  end;

  function Cnt_First_DgtCnt(pPr:tpPrime;lmt:UInt64;dgtCnt: Int32):nativeInt;
  //counting products of prime factors below limit
  //and memorize the smallest brilliant number above limit
  var
    pLo,tmp,res : UInt64;
    iLo,iHi : Int64;
  begin
    with BrilliantPos[dgtCnt] do
    begin
      iLO := MinIdx;
      iHi := MidIdx;
    end;
    result := iHi-iLo;
    res := pPr[iLo]*pPr[iHi+1];
     repeat
      iLo +=1;
      pLo := pPr[iLo];
      while (iHi >= iLo) AND (pPr[iHi]*pLo > Lmt) do
        iHi-=1;
      tmp := pPr[iHi+1]*pLo;
      if (tmp>lmt)AND (res>tmp)  then
        res := tmp;
      result += iHi-iLo+1;
    until (iHi < iLo);
    BrilliantPos[dgtCnt].Count_dgt := res;
  end;

  procedure GetLimitPos(pPr:tpPrime;MaxPrIdx:NativeUint);
  var
    lmt, p,idx1,dgtCnt : nativeuint;
    DeltaMax,DeltaMin,First,TotCnt: Uint64;
  begin
    lmt := 10;
    p := 0;
    idx1 := 0;
    dgtCnt := 0;
    TotCnt := 0;
    p := pPr[idx1];
    repeat
      BrilliantPos[dgtCnt].MinIdx := idx1;
      write(2*dgtCnt+1:3,':');
      First := p*p;
      p := Lmt DIV p;
      if p> 60000 then
        idx1:= BinSearch(pPr,MaxPrIdx,p)
      else
        while (p>pPr[idx1]) and (idx1 < MaxPrIdx) do
          idx1 += 1;
      BrilliantPos[dgtCnt].MidIdx := idx1;
      DeltaMin := Cnt_First_DgtCnt(pPr,lmt,dgtCnt);
      writeln(commatize(TotCnt+DeltaMin):23,commatize(First):24);
      lmt *=10;
      repeat
        idx1 +=1;
      until (sqr(pPr[idx1]) >= lmt)OR (idx1>=MaxPrIdx);
      p := pPr[idx1];
      BrilliantPos[dgtCnt].MaxIdx := idx1-1;
      //for both decimals just summation formula
      deltaMax := idx1-BrilliantPos[dgtCnt].MinIdx;
      deltaMax := (deltaMax*(deltaMax+1) DIV 2);
      TotCnt += deltaMax;
      First := BrilliantPos[dgtCnt].Count_dgt;
      write(2*dgtCnt+2:3,':');
      writeln(commatize(TotCnt):23,commatize(First):24);
      dgtCnt += 1;
      lmt*=10;
    until (idx1 >= MaxPrIdx) or(lmt>sqr(MaxRoot));
  end;

var
  primes :tPrime;
  pPr : tpPrime;
  T : INt64;
begin
  T := GetTickCount64;
  Sieve(primes,MaxRoot);
  Writeln('Sieving in ',GetTickCount64-T,' ms');
  T := GetTickCount64;

  pPr := @primes[0];
  Get_N_Brilliant(pPr,100);
  writeln('Digits          total count         first brilliant');
  GetLimitPos(pPr,High(primes));
  writeln('                         ',Commatize(sqr(primes[High(primes)])):26);
  Writeln('Counting in ',GetTickCount64-T,' ms');
  {$IFDEF WINDOWS}
    readln;
  {$ENDIF}
end.
