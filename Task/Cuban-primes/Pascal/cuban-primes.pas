program CubanPrimes;
{$IFDEF FPC}
  {$MODE DELPHI}
  {$OPTIMIZATION ON,Regvar,PEEPHOLE,CSE,ASMCSE}
  {$CODEALIGN proc=32}
{$ENDIF}
uses
  primTrial;
const
  COLUMNCOUNT = 10*10;

procedure FormOut(Cuban:Uint64;ColSize:Uint32);
var
  s : String;
  pI,pJ :pChar;
  i,j : NativeInt;
Begin
  str(Cuban,s);
  i := length(s);
  If i>3 then
  Begin
    //extend s by the count of comma to be inserted
    j := i+ (i-1) div 3;
    setlength(s,j);
    pI := @s[i];
    pJ := @s[j];
    while i > 3 do
    Begin
       // copy 3 digits
       pJ^ := pI^;dec(pJ);dec(pI);
       pJ^ := pI^;dec(pJ);dec(pI);
       pJ^ := pI^;dec(pJ);dec(pI);
       // insert comma
       pJ^ := ',';dec(pJ);
       dec(i,3);
    end;
    //the digits in front are in the right place
  end;
  write(s:ColSize);
end;

procedure OutFirstCntCubPrimes(Cnt : Int32;ColCnt : Int32);
var
  cbDelta1,
  cbDelta2  : Uint64;
  ClCnt,ColSize : NativeInt;
Begin
  If Cnt <= 0 then
    EXIT;
  IF ColCnt <= 0 then
    ColCnt := 1;
  ColSize := COLUMNCOUNT DIV ColCnt;
  dec(ColCnt);

  ClCnt := ColCnt;
  cbDelta1 := 0;
  cbDelta2 := 1;

  repeat
    if isPrime(cbDelta2) then
    Begin
      FormOut(cbDelta2,ColSize);
      dec(Cnt);

      dec(ClCnt);
      If ClCnt < 0 then
      Begin
        Writeln;
        ClCnt := ColCnt;
      end;
    end;
    inc(cbDelta1,6);// 0,6,12,18...
    inc(cbDelta2,cbDelta1);//1,7,19,35...
  until Cnt<= 0;

  writeln;
end;

procedure OutNthCubPrime(n : Int32);
var
  cbDelta1,
  cbDelta2  : Uint64;
Begin
  If n <= 0 then
    EXIT;
  cbDelta1 := 0;
  cbDelta2 := 1;

  repeat
    inc(cbDelta1,6);
    inc(cbDelta2,cbDelta1);
    if isPrime(cbDelta2) then
      dec(n);
  until n<=0;

  FormOut(cbDelta2,20);
  writeln;
end;

Begin
  OutFirstCntCubPrimes(200,10);
  OutNthCubPrime(100000);
end.
