program Perftotient;
{$IFdef FPC}
  {$MODE DELPHI} {$CodeAlign proc=32,loop=1}
{$IFEND}
uses
  sysutils;
const
  cLimit = 57395631;//177147;//4190263;//57395631;//1162261467;//
//global
var
  TotientList : array of LongWord;
  Sieve : Array of byte;
  SolList : array of LongWord;
  T1,T0 : INt64;

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
  pTotLst : pLongWord;
  pSieve  : pByte;
  test : double;
  i: NativeInt;
  p,j,k,svLimit : NativeUint;
Begin
  SieveInit(len);
  T0:= GetTickCount64;
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
//  Test := (1-1/p);
    while j <= cLimit do
    Begin
//    pTotLst[j] := trunc(pTotLst[j]*Test);
      k:= pTotLst[j];
      pTotLst[j]:= k-(k DIV p);
      inc(j,p);
    end;
    inc(i);
  until i=0;

  T1:= GetTickCount64;
  writeln('totient calculated in ',T1-T0,' ms');
  setlength(sieve,0);
end;

function GetPerfectTotient(len: NativeUint):NativeUint;
var
  pTotLst : pLongWord;
  i,sum: NativeUint;
Begin
  T0:= GetTickCount64;
  pTotLst := @TotientList[0];
  setlength(SolList,100);
  result := 0;
  For i := 3 to Len do
  Begin
    sum := pTotLst[i];
    pTotLst[i] := sum+pTotLst[sum];
  end;
  //Check for solution ( IF ) in seperate loop ,reduces time consuption ~ 12% for this function
  For i := 3 to Len do
    IF pTotLst[i] =i then
    Begin
      SolList[result] := i;
      inc(result);
    end;

  T1:= GetTickCount64;
  setlength(SolList,result);
  writeln('calculated totientsum in ',T1-T0,' ms');
  writeln('found ',result,' perfect totient numbers');
end;

var
  j,k : NativeUint;

Begin
  TotientInit(climit);
  GetPerfectTotient(climit);
  k := 0;
  For j := 0 to High(Sollist) do
  Begin
    inc(k);
    if k > 4 then
    Begin
      writeln(Sollist[j]);
      k := 0;
    end
    else
      write(Sollist[j],',');
  end;
end.
