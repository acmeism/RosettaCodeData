program PrimSumUpTo13_GMP;
{$IFDEF FPC}
  {$OPTIMIZATION ON,ALL}
  {$MODE DELPHI}
{$ELSE}
  {$APPTYPE CONSOLE}
{$ENDIF}
uses
  sysutils,gmp;

type
  tDigits = array[0..3] of Uint32;
const
  MAXNUM = 199;//999
var
  //split factors of n! in Uint64 groups
  Fakul : array[0..MAXNUM] of UInt64;
  IdxLimits : array[0..MAXNUM DIV 3] of word;
  gblPrimDgtCnt :tDigits;

  gblSum,
  gbldelta : MPInteger; // multi precision (big) integers selve cleaning
  s : AnsiString;

procedure Init;
var
  i,j,tmp,n :NativeUint;
Begin
  //generate n! by Uint64 factors
  j := 1;
  n := 0;
  For i := 1 to MAXNUM do
  begin
    tmp := j;
    j *= i;
    if j div i <> tmp then
    Begin
      IdxLimits[n]:= i-1;
      j := i;
      inc(n);
    end;
    Fakul[i] := j;
  end;

  setlength(s,512);// 997 -> 166
  z_init_set_ui(gblSum,0);
  z_init_set_ui(gbldelta,0);
end;

function isPrime(n: NativeUint):boolean;
var
  i : NativeUInt;
Begin
  result := (n>1);
  if n<4 then
    EXIT;
  result := false;
  if n AND 1 = 0 then
    EXIT;
  i := 3;
  while i*i<= n do
  Begin
    If n MOD i = 0 then
      EXIT;
    inc(i,2);
  end;
  result := true;
end;

procedure Sort(var t:tDigits);
// sorting descending to reduce calculations
var
  i,j,k: NativeUint;
  temp : Uint32;
Begin
  For k := 0 to high(tdigits)-1 do
  Begin
    temp:= t[k];
    j := k;
    For i := k+1 to high(tdigits) do
    Begin
      if temp < t[i] then
      Begin
        temp := t[i];
        j := i;
      end;
    end;
    t[j] := t[k];
    t[k] := temp;
  end;
end;

function calcOne(f,n: NativeUint):NativeUint;
var
  i,idx,MaxMulLmt : NativeUint;
Begin
  result := f;
  if n = 0 then
    EXIT;

  MaxMulLmt := High(MaxMulLmt) DIV (f+n);
  z_mul_ui(gbldelta,gbldelta,result);
  inc(result);
  if n > 1 then
  Begin
    //multiply by parts of (f+n)!/f! with max Uint64 factors
    i := 2;
    while (i<=n) do
    begin
      idx := 1;
      while (i<=n) AND (idx<MaxMulLmt) do
      Begin
        idx *= result;
        inc(i);
        inc(result);
      end;
      z_mul_ui(gbldelta,gbldelta,idx);
    end;

    //divide by n! with max Uint64 divisors
    idx := 0;
    if n > IdxLimits[idx] then
      repeat
        z_divexact_ui(gbldelta,gbldelta,Fakul[IdxLimits[idx]]);
        inc(idx);
      until IdxLimits[idx] >= n;
    z_divexact_ui(gbldelta,gbldelta,Fakul[n]);
  end;
end;

procedure CalcPermCount;
//TempDgtCnt[0] = 3 and TempDgtCnt[1..3]= 2 -> dgtcnt = 3+3*2= 9
//permcount = dgtcnt! /(TempDgtCnt[0]!*TempDgtCnt[1]!*TempDgtCnt[2]!*TempDgtCnt[3]!);
//nom of n!  = 1,2,3, 4,5, 6,7, 8,9
//denom      = 1,2,3, 1,2, 1,2, 1,2
var
  TempDgtCnt : tdigits;
  f : NativeUint;
begin
  TempDgtCnt := gblPrimDgtCnt;
  Sort(TempDgtCnt);
  //jump over 1/1*2/2*3/3*4/4*..*
  //res := 1;
  f := TempDgtCnt[0]+1;
  z_set_ui(gbldelta,1);

  f := calcOne(f,TempDgtCnt[1]);
  f := calcOne(f,TempDgtCnt[2]);
  f := calcOne(f,TempDgtCnt[3]);

  z_add(gblSum,gblSum,gblDelta);
end;

procedure check32(sum3 :NativeInt);
var
  n3 : nativeInt;
begin
   n3 := sum3 DIV 3;
   gblPrimDgtCnt[1]:= 0;
   while n3 >= 0 do
   begin
     //divisible by 2
     if sum3 AND 1 = 0 then
     Begin
       gblPrimDgtCnt[0] := sum3 shr 1;
       CalcPermCount;
     end;
     sum3 -= 3;
     inc(gblPrimDgtCnt[1]);
     dec(n3);
   end;
end;
procedure CheckAll(num:NativeUint);
var
  sum7,sum5: NativeInt;
BEGIN
  z_set_ui(gblSum,0);
  sum7 :=num;
  gblPrimDgtCnt[3] := 0;
  while sum7 >=0 do
  Begin
    sum5 := sum7;
    gblPrimDgtCnt[2]:=0;
    while sum5 >= 0 do
    Begin
      check32(sum5);
      dec(sum5,5);
      inc(gblPrimDgtCnt[2]);
    end;
    inc(gblPrimDgtCnt[3]);
    dec(sum7,7);
  end;
end;

var
  T0 : Int64;
  Num : NativeUint;
BEGIN
  Init;

  T0 := GettickCount64;
  // Number crunching goes here
  writeln('Sum':6,'Count of arrangements':25);
  For num := 2 to MAXNUM do
    IF isPrime(Num) then
    Begin
      CheckAll(num);

      z_get_str(pChar(s),10,gblSum);
      writeln(num:6,'  ',pChar(s));
    end;
  writeln('Time taken : ',GettickCount64-T0,' ms');

  z_clear(gblSum);
  z_clear(gbldelta);
END.
