program PrimSumUpTo13;
{$IFDEF FPC}
   {$MODE DELPHI}
{$ELSE}
  {$APPTYPE CONSOLE}
{$ENDIF}
uses
  sysutils;

type
  tDigits = array[0..3] of Uint32;
const
  MAXNUM = 113;
var
 gblPrimDgtCnt :tDigits;
 gblCount: NativeUint;

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

function CalcPermCount:NativeUint;
//TempDgtCnt[0] = 3 and TempDgtCnt[1..3]= 2 -> dgtcnt = 3+3*2= 9
//permcount = dgtcnt! /(TempDgtCnt[0]!*TempDgtCnt[1]!*TempDgtCnt[2]!*TempDgtCnt[3]!);
//nom of n!  = 1,2,3, 4,5, 6,7, 8,9
//denom      = 1,2,3, 1,2, 1,2, 1,2
var
  TempDgtCnt : tdigits;
  i,f : NativeUint;
begin
  TempDgtCnt := gblPrimDgtCnt;
  Sort(TempDgtCnt);
  //jump over 1/1*2/2*3/3*4/4*..* TempDgtCnt[0]/TempDgtCnt[0]
  f := TempDgtCnt[0]+1;
  result :=1;

  For i := 1 to TempDgtCnt[1] do
  Begin
    result := (result*f) DIV i;
    inc(f);
  end;
  For i := 1 to TempDgtCnt[2] do
  Begin
    result := (result*f) DIV i;
    inc(f);
  end;
  For i := 1 to TempDgtCnt[3] do
  Begin
    result := (result*f) DIV i;
    inc(f);
  end;
end;

procedure check32(sum3 :NativeUint);
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
       inc(gblCount,CalcPermCount);
       sum3 -= 3;
       inc(gblPrimDgtCnt[1]);
       dec(n3);
     end;
     sum3 -= 3;
     inc(gblPrimDgtCnt[1]);
     dec(n3);
   end;
end;

var
  Num : NativeUint;
  i,sum7,sum5: NativeInt;
BEGIN
  writeln('Sum':6,'Count of arrangements':25);

  Num := 1;
  repeat
    inc(num);
    if Not(isPrime(Num)) then
      CONTINUE;
    gblCount := 0;
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
    writeln(num:6,gblCount:25,'   ');
  until num > MAXNUM;
END.
