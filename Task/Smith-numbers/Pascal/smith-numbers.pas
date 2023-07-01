program SmithNum;
{$IFDEF FPC}
  {$MODE objFPC} //result and  useful for x64
  {$CODEALIGN PROC=64}
{$ENDIF}
uses
  sysutils;
type
  tdigit  = byte;
  tSum    = LongInt;
const
  base = 10;
  //maxDigitCnt *(base-1) <= High(tSum)
  //maxDigitCnt <= High(tSum) DIV (base-1);
  maxDigitCnt = 16;

  StartPrimNo = 6;
  csegsieveSIze = 2*3*5*7*11*13;//prime 0..5
type
  tDgtSum = record
              dgtNum : LongInt;
              dgtSum : tSum;
              dgts   : array[0..maxDigitCnt-1] of tdigit;
            end;
  tNumFactype = word;
  tnumFactor = record
                 numfacCnt: tNumFactype;
                 numfacts : array[1..15] of tNumFactype;
               end;
  tpnumFactor= ^tnumFactor;

  tsieveprim = record
                 spPrim   : Word;
                 spDgtsum : Word;
                 spOffset : LongWord;
               end;
  tpsieveprim = ^tsieveprim;

  tsievePrimarr  = array[0..6542-1] of tsieveprim;
  tsegmSieve     = array[1..csegsieveSIze] of tnumFactor;

var
  Primarr:tsievePrimarr;
  copySieve,
  actSieve : tsegmSieve;
  PrimDgtSum :tDgtSum;
  PrimCnt : NativeInt;

function IncDgtSum(var ds:tDgtSum):boolean;
//add 1 to dgts and corrects sum of Digits
//return if overflow happens
var
  i : NativeInt;
Begin
  i := High(ds.dgts);
  inc(ds.dgtNum);
  repeat
    IF ds.dgts[i] < Base-1 then
    //add one and done
    Begin
      inc(ds.dgts[i]);
      inc(ds.dgtSum);
      BREAK;
    end
    else
    Begin
      ds.dgts[i] := 0;
      dec(ds.dgtSum,Base-1);
    end;
    dec(i);
 until i < Low(ds.dgts);
 result := i < Low(ds.dgts)
end;

procedure OutDgtSum(const ds:tDgtSum);
var
  i : NativeInt;
Begin
  i := Low(ds.dgts);
  repeat
    write(ds.dgts[i]:3);
    inc(i);
  until i > High(ds.dgts);
  writeln(' sum of digits :  ',ds.dgtSum:3);
end;

procedure OutSieve(var s:tsegmSieve);
var
  i,j : NativeInt;
Begin
  For i := Low(s) to High(s) do
    with s[i] do
    Begin
      write(i:6,numfacCnt:4);
      For j := 1 to numfacCnt do
        write(numFacts[j]:5);
      writeln;
    end;
end;

procedure SieveForPrimes;
// sieve for all primes < High(Word)
var
  sieve : array of byte;
  pS : pByte;
  p,i   : NativeInt;
Begin
  setlength(sieve,High(Word));
  Fillchar(sieve[Low(sieve)],length(sieve),#0);
  pS:= @sieve[0]; //zero based
  dec(pS);// make it one based
  //sieve
  p := 2;
  repeat
    i := p*p;
    IF i> High(Word) then
      BREAK;
    repeat pS[i] := 1; inc(i,p); until i > High(Word);
    repeat inc(p) until pS[p] = 0;
  until false;
  //now fill array of primes
  fillchar(PrimDgtSum,SizeOf(PrimDgtSum),#0);
  IncDgtSum(PrimDgtSum);//1
  i := 0;
  For p := 2 to High(Word) do
  Begin
    IncDgtSum(PrimDgtSum);
    if pS[p] = 0 then
    Begin
      with PrimArr[i] do
      Begin
        spOffset := 2*p;//start at 2*prime
        spPrim   := p;
        spDgtsum := PrimDgtSum.dgtSum;
      end;
      inc(i);
    end;
  end;
  PrimCnt := i-1;
end;

procedure MarkWithPrime(SpIdx:NativeInt;var sf:tsegmSieve);
var
  i : NativeInt;
  pSf :^tnumFactor;
  MarkPrime : NativeInt;
Begin
  with Primarr[SpIdx] do
  Begin
    MarkPrime := spPrim;
    i :=  spOffSet;
    IF i <= csegsieveSize then
    Begin
      pSf := @sf[i];
      repeat
        pSf^.numFacts[pSf^.numfacCnt+1] := SpIdx;
        inc(pSf^.numfacCnt);
        inc(pSf,MarkPrime);
        inc(i,MarkPrime);
      until i > csegsieveSize;
    end;
    spOffset := i-csegsieveSize;
  end;
end;

procedure InitcopySieve(var cs:tsegmSieve);
var
  pr: NativeInt;
Begin
  fillchar(cs[Low(cs)],sizeOf(cs),#0);
  For Pr := 0 to 5 do
  Begin
    with Primarr[pr] do
     spOffset := spPrim;//mark the prime too
    MarkWithPrime(pr,cs);
  end;
end;

procedure MarkNextSieve(var s:tsegmSieve);
var
  idx: NativeInt;
Begin
  s:= copySieve;
  For idx := StartPrimNo to PrimCnt do
    MarkWithPrime(idx,s);
end;

function DgtSumInt(n: NativeUInt):NativeUInt;
var
  r : NativeUInt;
Begin
  result := 0;
  repeat
    r := n div base;
    inc(result,n-base*r);
    n := r
  until r = 0;
end;

{function DgtSumOfFac(pN: tpnumFactor;dgtNo:tDgtSum):boolean;}
function TestSmithNum(pN: tpnumFactor;dgtNo:tDgtSum):boolean;
var
  i,k,r,dgtSumI,dgtSumTarget : NativeUInt;
  pSp:tpsieveprim;
  pNumFact : ^tNumFactype;
Begin
  i := dgtNo.dgtNum;
  dgtSumTarget :=dgtNo.dgtSum;

  dgtSumI := 0;
  with pN^ do
  Begin
    k := numfacCnt;
    pNumFact := @numfacts[k];
  end;

  For k := k-1 downto 0 do
  Begin
    pSp := @PrimArr[pNumFact^];
    r := i DIV pSp^.spPrim;
    repeat
      i := r;
      r := r DIV pSp^.spPrim;
      inc(dgtSumI,pSp^.spDgtsum);
    until (i - r* pSp^.spPrim) <> 0;
    IF dgtSumI > dgtSumTarget then
    Begin
      result := false;
      EXIT;
    end;
    dec(pNumFact);
  end;
  If i <> 1 then
    inc(dgtSumI,DgtSumInt(i));
  result := dgtSumI = dgtSumTarget
end;

function CheckSmithNo(var s:tsegmSieve;var dgtNo:tDgtSum;Lmt:NativeInt=csegsieveSIze):NativeUInt;
var
  pNumFac : tpNumFactor;
  i : NativeInt;
Begin
  result := 0;
  i := low(s);
  pNumFac := @s[i];
  For i := i to lmt do
  Begin
    incDgtSum(dgtNo);
    IF pNumFac^.numfacCnt<> 0 then
      IF TestSmithNum(pNumFac,dgtNo) then
      Begin
        inc(result);
        //Mark as smith number
        inc(pNumFac^.numfacCnt,1 shl 15);
      end;
    inc(pNumFac);
  end;
end;

const
  limit = 100*1000*1000;
var
  actualNo :tDgtSum;
  i,s : NativeInt;
Begin
  SieveForPrimes;
  InitcopySieve(copySieve);
  i := 1;
  s:= -6;//- 2,3,5,7,11,13

  fillchar(actualNo,SizeOf(actualNo),#0);
  while i < Limit-csegsieveSize do
  Begin
    MarkNextSieve(actSieve);
    inc(s,CheckSmithNo(actSieve,actualNo));
    inc(i, csegsieveSize);
  end;
  //check the rest
  MarkNextSieve(actSieve);
  inc(s,CheckSmithNo(actSieve,actualNo,Limit-i+1));
  write(s:8,' smith-numbers up to ',actualNo.dgtnum:10);
end.
