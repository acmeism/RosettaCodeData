program Primorial;
{$IFDEF FPC} {$MODE DELPHI} {$ENDIF}
uses
  sysutils;
var
  primes : array[0..1000000] of LongInt;

procedure InitSieve;
const
  HiSieve = 15485864;
var
  sieve: array of boolean;
  i, j: NativeInt;
Begin
  setlength(sieve,HiSieve);
  fillchar(sieve[0],HiSieve,chr(ord(True)));
  For i := 2 to Trunc(sqrt(HiSieve)) do
    IF sieve[i] then Begin
      j := i*i;repeat sieve[j]:= false;inc(j,i);until j>= HiSieve-1;end;
  i:= 2;j:= 1;
  repeat
    IF sieve[i] then begin primes[j]:= i;inc(j) end;
    inc(i);
  until i > HiSieve;
  primes[0] := 1;setlength(sieve,0);
end;

function getPrimorial(n:NativeInt):Uint64;
Begin
  result := ORD(n>=0);
  IF (n >= 0) AND (n < 16) then
    repeat result := result*primes[n]; dec(n); until n < 1;
end;

function getPrimorialDecDigits(n:NativeInt):NativeInt;
var
  res: extended;
Begin
  result := -1;
  IF (n > 0) AND (n <= 1000*1000) then
  Begin
    res := 0;
    repeat res := res+ln(primes[n]); dec(n); until n < 1;
    result := trunc(res/ln(10))+1;
  end;
end;

function getPrimorialExact(n:NativeInt):NativeInt;
const
  LongWordDec = 1000000000;
var
  MulArr : array of LongWord;
  pMul : ^LongWord;
  Mul1,prod,carry : Uint64;
  i,j,ul : NativeInt;
begin
  i := getPrimorialDecDigits(n) DIV 9 +10;
  Setlength(MulArr,i);
  Ul := 0;
  MulArr[Ul]:= 1;
  i := 1;
  repeat
    Mul1 := 1;
    //Make Mul1 as large as possible
    while (i<= n) AND ((LongWordDec DIV MUL1) >= primes[i])  do
      Begin Mul1 := Mul1*primes[i]; inc(i); end;
    carry := 0;
    pMul := @MulArr[0];
    For j := 0 to UL do
    Begin
      prod  := Mul1*pMul^+Carry;
      Carry := prod Div LongWordDec;
      pMul^ := Prod - Carry*LongWordDec;
      inc(pMul);
    end;
    IF Carry <> 0 then Begin inc(Ul);pMul^:= Carry; End;
  until i> n;
  //count digits
  i := Ul*9;
  Carry := MulArr[Ul];
  repeat
    Carry := Carry DIV 10;
    inc(i);
  until Carry = 0;
  result := i;
end;


var
  i: NativeInt;
Begin
  InitSieve;
  write('Primorial (0->9) ');
  For i := 0 to 9 do
    write(getPrimorial(i),',');
  writeln(#8#32#13#10);
  i:= 10;
  repeat
    writeln('Primorial (',i,') = digits ',
            getPrimorialDecDigits(i),' digits');
    i := i*10;
  until i> 1000000;
  writeln;
  i:= 10;
  repeat
    writeln('PrimorialExact (',i,') = digits ',
            getPrimorialExact(i),' digits');
    i := i*10;
  until i> 100000;
end.
