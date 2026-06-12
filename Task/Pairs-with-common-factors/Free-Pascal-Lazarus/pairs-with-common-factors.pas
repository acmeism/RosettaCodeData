program PairsWithCommonFactors;
{$IFdef FPC} {$MODE DELPHI} {$Optimization ON,ALL}{$IFEND}
{$IFdef Windows} {$APPTYPE CONSOLE}{$IFEND}
const
  cLimit = 1000*1000*1000;
//global
type
  TElem= Uint64;
  tpElem = pUint64;

  myString = String[31];

var
  TotientList : array of TElem;
  Sieve : Array of byte;

function Numb2USA(n:Uint64):myString;
const
//extend s by the count of comma to be inserted
  deltaLength : array[0..24] of byte =
    (0,0,0,0,1,1,1,2,2,2,3,3,3,4,4,4,5,5,5,6,6,6,7,7,7);
var
  pI :pChar;
  i,j : NativeInt;
Begin
  str(n,result);
  i := length(result);
 //extend s by the count of comma to be inserted
// j := i+ (i-1) div 3;
  j := i+deltaLength[i];
  if i<> j then
  Begin
    setlength(result,j);
    pI := @result[1];
    dec(pI);
    while i > 3 do
    Begin
       //copy 3 digits
       pI[j] := pI[i];
       pI[j-1] := pI[i-1];
       pI[j-2] := pI[i-2];
       // insert comma
       pI[j-3] := ',';
       dec(i,3);
       dec(j,4);
    end;
  end;
end;

procedure SieveInit(svLimit:NativeUint);
var
  pSieve:pByte;
  i,j,pr :NativeUint;
Begin
  svlimit := (svLimit+1) DIV 2;
  setlength(sieve,svlimit+1);
  pSieve := @Sieve[0];
  For i := 1 to svlimit do
  Begin
    IF pSieve[i]= 0 then
    Begin
      pr := 2*i+1;
      j := (sqr(pr)-1) DIV 2;
      IF  j> svlimit then
        BREAK;
      repeat
        pSieve[j]:= 1;
        inc(j,pr);
      until j> svlimit;
    end;
  end;
  pr := 0;
  j := 0;
  For i := 1 to svlimit do
  Begin
    IF pSieve[i]= 0 then
    Begin
      pSieve[j] := i-pr;
      inc(j);
      pr := i;
    end;
  end;
  setlength(sieve,j);
end;

procedure TotientInit(len: NativeUint);
var
  pTotLst : tpElem;
  pSieve  : pByte;
  i: NativeInt;
  p,j,k,svLimit : NativeUint;
Begin
  SieveInit(len);
  setlength(TotientList,len+12);
  pTotLst := @TotientList[0];

//Fill totient with simple start values for odd and even numbers
//and multiples of 3
  j := 1;
  k := 1;// k == j DIV 2
  p := 1;// p == j div 3;
  repeat
    pTotLst[j] := j;//1
    pTotLst[j+1] := k;//2 j DIV 2; //2
    inc(k);
    inc(j,2);
    pTotLst[j] := j-p;//3
    inc(p);
    pTotLst[j+1] := k;//4  j div 2
    inc(k);
    inc(j,2);
    pTotLst[j] := j;//5
    pTotLst[j+1] := p;//6   j DIV 3 <=  (div 2) * 2 DIV/3
    inc(j,2);
    inc(p);
    inc(k);
  until j>len+6;

//correct values of totient by prime factors
  svLimit := High(sieve);
  p := 3;// starting after 3
  pSieve := @Sieve[svLimit+1];
  i := -svlimit;
  repeat
    p := p+2*pSieve[i];
    j := p;
    while j <= cLimit do
    Begin
      k:= pTotLst[j];
      pTotLst[j]:= k-(k DIV p);
      inc(j,p);
    end;
    inc(i);
  until i=0;
  //primes not needed anymore
  setlength(sieve,0);
end;

procedure CountOfPairs(len: NativeUint);
var
  pTotLst : tpElem;
  i,a_n,sum,Totient: tElem;
Begin
  pTotLst := @TotientList[0];
  sum := 1;
  a_n := 2; // sums to i*(i-1)/2 +1
  For i := 2 to len do
  Begin
    Totient := pTotLst[i];// relict for print data
    sum += Totient;
    pTotLst[i] := a_n-sum;
    a_n += i;
  end;
  TotientList[1] := 0;
end;

var
  i,k : NativeUint;
Begin
  TotientInit(climit);
  CountOfPairs(climit);
  i := 1;
  Repeat
    For k := 9 downto 0 do
    begin
      write(TotientList[i]:6);
      inc(i);
    end;
    writeln;
  until i>99;
  writeln;
  writeln('Some values #');
  i := 10;
  repeat
    writeln(Numb2USA(i):13,Numb2USA(TotientList[i]):25);
    i *= 10;
  until i > climit;
end.
