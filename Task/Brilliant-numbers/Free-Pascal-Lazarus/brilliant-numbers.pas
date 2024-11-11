program BrilliantNumbers;
{$IFDEF FPC}
  {$MODE Delphi}
  {$Optimization ON,All}
{$ENDIF}
{$IFDEF WINDOWS}
  {$APPTYPE CONSOLE}
{$ENDIF}

uses
  SysUtils,classes;
const
  MaxRoot = 100*1000*1000+2310;//+2310 to get next prime beyond limit
type
  tPrimeDelta = array of Uint8;
  tBrilliant = record
                 pMin,  // start for dgtcnt
                 pMid,  // start for dgtcnt+1
                 pMax,  // end   for dgtcnt+1
                 MinIdx,
                 MidIdx,
                 MaxIdx : Uint32;
               end;
var
  BrilliantPos :array [0..8] of TBrilliant;
  OddPowP : Uint32;

  function BuildWheel(var primes: tPrimeDelta): longint;
  //pre-sieve with small primes,returns the last used prime
  var
    //wheelprimes = 2,3,5,7,11. ;wheelsize = product[i= 0..wpno-1]wheelprimes[i] > Uint64|i> 13
    wheelprimes: array[0..15] of byte;
    wheelSize, wpno, pr, pw, i, k: longword;
  begin
    pr := 1;
    primes[1] := 1;
    WheelSize := 1;
    wpno := 0;
    repeat
      Inc(pr);
      pw := pr;
      if pw > wheelsize then
        Dec(pw, wheelsize);
      if Primes[pw]<>0 then
      begin
        k := WheelSize + 1;
        for i := 1 to pr - 1 do
        begin
          Inc(k, WheelSize);
          if k < High(primes) then
            move(primes[1], primes[k - WheelSize], WheelSize)
          else
          begin
            move(primes[1], primes[k - WheelSize], High(primes) - WheelSize * i);
            break;
          end;
        end;
        Dec(k);
        if k > High(primes) then
          k := High(primes);
        wheelPrimes[wpno] := pr;
        primes[pr] := 0;

        i := sqr(pr);
        while i <= k do
        begin
          primes[i] := 0;
          Inc(i, pr);
        end;

        Inc(wpno);
        WheelSize := k;
      end;
    until WheelSize >= High(primes);
    while wpno > 0 do
    begin
      Dec(wpno);
      primes[wheelPrimes[wpno]] := 1;
    end;
    Result := pr;
  end;

  procedure Sieve(var primes: tPrimeDelta);
  var
    pPrime: pUint8;
    sieveprime, delFact: longword;
  begin
    sieveprime := BuildWheel(primes);
    pPrime := @primes[0];
    repeat
      repeat
        Inc(sieveprime);
      until pPrime[sieveprime]<>0;
      delFact := High(primes) div sieveprime;
      if delFact < sieveprime then
        BREAK;
      inc(delFact);
      repeat
        repeat
          Dec(delFact);
        until pPrime[delFact]<>0;
        pPrime[sieveprime * delFact] := 0;
      until delFact < sieveprime;
    until False;
    primes[1] := 0;
  end;

  procedure GetPrimeDelta(var prD:tPrimeDelta;size: int32);
  var
    pPD : pUint8;
    idx,LastP,p : Uint32;
  Begin
    setlength(prD, 0);
    setlength(prD, size + 1);
    Sieve(prD);
    pPD := @prD[0];
    idx := 0;
    LastP := 0;
    p := 0;
    repeat
      if pPD[p] <> 0 then
      begin
        pPD[idx] := p-LastP;
        LastP := p;
        inc(idx);
      end;
      inc(p);
    until p> Size;
    Setlength(prD,idx);
   end;

   function Cnt_First_DgtCnt(pPD:pUint8;lmt:UInt64;dgtCnt: Int32):nativeUint;
   //counting products of prime factors smaller than limit
   var
     pLo,pHi,iLo,iHi : UInt64;
   begin
     with BrilliantPos[dgtCnt] do
     begin
       pLo := pMin;
       iLO := MinIdx;
       pHi := pMid;
       iHi := MidIdx;
     end;
     result := iHi-iLo+1;
     repeat
       iLo+=1;
       pLO := pLo+pPD[iLo];
       if pLo = pHi then
       begin
         if sqr(pLo) < Lmt then
           pLO := pLo+pPD[iLo+1];
         OddPowP := pLo;
         EXIT(result+1);
       end;
       while (pHi >= pLo) AND (pHi*pLo > lmt) do
       begin
         pHi := pHi-pPD[iHi];
         iHi-=1;
       end;
       result += iHi-iLo+1;
     until (pHi < pLo);
     OddPowP := pLo;
   end;

   procedure GetLimitPos(pPD:pUint8;MaxPrIdx:NativeUint);
   var
     lmt, p,pmin,idx1,dgtCnt : nativeuint;
     DeltaMax,DeltaMin,TotCnt: Uint64;
   begin
     lmt := 10;
     p := 0;
     idx1 := 0;
     dgtCnt := 0;
     TotCnt := 0;
     p += pPD[idx1];
     repeat
       BrilliantPos[dgtCnt].pMin:= p;
       BrilliantPos[dgtCnt].MinIdx := idx1;
       write('10^',2*dgtCnt+1:2,':',p:10);
       pMin := p;
       while (pMin*p < lmt) and (idx1 < MaxPrIdx) do
       begin
         idx1 += 1;
         p += pPD[idx1];
       end;
       pMin := p-pPD[idx1];
       BrilliantPos[dgtCnt].pMid := pMin;
       BrilliantPos[dgtCnt].MidIdx := idx1-1;
       DeltaMin := Cnt_First_DgtCnt(pPD,lmt,dgtCnt);
       writeln(DeltaMin:20,TotCnt+DeltaMin:20);
       lmt *=10;
       while (p*p <= lmt) AND (idx1 < MaxPrIdx) do
       begin
         idx1 += 1;
         p += pPD[idx1];
       end;
       pMin := p-pPD[idx1];
       BrilliantPos[dgtCnt].pMax := pMin;
       BrilliantPos[dgtCnt].MaxIdx := idx1-1;

       //for both decimals just summation formula
       deltaMax := idx1-BrilliantPos[dgtCnt].MinIdx;
       deltaMax := (deltaMax*(deltaMax+1) DIV 2);
       TotCnt += deltaMax;
       write('10^',2*dgtCnt+2:2,':',OddPowP:10);
       writeln(DeltaMax-DeltaMin:20,TotCnt:20);
       dgtCnt += 1;
       lmt*=10;
     until (idx1 >= MaxPrIdx) or(lmt>sqr(MaxRoot));
     writeln(p:16);
   end;

var
  primeDelta :TprimeDelta;
  T : INt64;
  pPD : pUint8;
begin
  T := GetTickCount64;
  GetPrimeDelta(primeDelta,MaxRoot);
  Writeln('Sieving in ',GetTickCount64-T,' ms');
  T := GetTickCount64;
  pPD := @primeDelta[0];
//         10^ 1:         2                   3                   3
  writeln('Limit first prime         deltaCount         Total Count');
  GetLimitPos(pPD,High(primeDelta));
  Writeln('Counting in ',GetTickCount64-T,' ms');
  {$IFDEF WINDOWS}
    readln;
  {$ENDIF}
end.
