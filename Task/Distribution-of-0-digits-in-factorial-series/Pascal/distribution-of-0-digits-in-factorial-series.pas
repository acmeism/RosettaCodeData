program Factorial;
{$IFDEF FPC} {$MODE DELPHI} {$Optimization ON,ALL} {$ENDIF}
uses
  sysutils;
type
  tMul = array of LongWord;
  tpMul = pLongWord;
const
  LongWordDec = 1000*1000*1000;
  LIMIT = 50000;
var
  CountOfZero : array[0..999] of byte;
  SumOfRatio :array[0..LIMIT] of extended;


procedure OutMul(pMul:tpMul;Lmt :NativeInt);
// for testing
Begin
  write(pMul[lmt]);
  For lmt := lmt-1  downto 0 do
    write(Format('%.9d',[pMul[lmt]]));
  writeln;
end;

procedure InitCoZ;
//Init Lookup table for 3 digits
var
  x,y : integer;
begin
  fillchar(CountOfZero,SizeOf(CountOfZero),#0);
  CountOfZero[0] := 3; //000
  For x := 1 to 9 do
  Begin
    CountOfZero[x] := 2;     //00x
    CountOfZero[10*x] := 2;  //0x0
    CountOfZero[100*x] := 2; //x00
    y := 10;
    repeat
      CountOfZero[y+x] := 1;      //0yx
      CountOfZero[10*y+x] := 1;   //y0x
      CountOfZero[10*(y+x)] := 1; //yx0
      inc(y,10)
    until y > 100;
  end;
end;

function getFactorialDecDigits(n:NativeInt):NativeInt;
var
  res: extended;
Begin
  result := -1;
  IF (n > 0) AND (n <= 1000*1000) then
  Begin
    res := 0;
    repeat res := res+ln(n); dec(n); until n < 2;
    result := trunc(res/ln(10))+1;
  end;
end;

function CntZero(pMul:tpMul;Lmt :NativeInt):NativeUint;
//count zeros in Base 1,000,000,000 number
var
  q,r : LongWord;
  i : NativeInt;
begin
  result := 0;
  For i := Lmt-1 downto 0 do
  Begin
    q := pMul[i];
    r := q DIV 1000;
    result +=CountOfZero[q-1000*r];//q-1000*r == q mod 1000
    q := r;
    r := q DIV 1000;
    result +=CountOfZero[q-1000*r];
    q := r;
    r := q DIV 1000;
    result +=CountOfZero[q-1000*r];
  end;
//special case first digits no leading '0'
  q := pMul[lmt];
  while q >= 1000 do
  begin
    r := q DIV 1000;
    result +=CountOfZero[q-1000*r];
    q := r;
  end;
  while q > 0 do
  begin
    r := q DIV 10;
    result += Ord( q-10*r= 0);
    q := r;
  end;
end;

function GetCoD(pMul:tpMul;Lmt :NativeInt):NativeUint;
//count of decimal digits
var
  i : longWord;
begin
  result := 9*Lmt;
  i := pMul[Lmt];
  while i > 1000 do
  begin
    i := i DIV 1000;
    inc(result,3);
  end;
  while i > 0 do
  begin
    i := i DIV 10;
    inc(result);
  end;
end;

procedure DoChecks(pMul:tpMul;Lmt,i :NativeInt);
//(extended(1.0)* makes TIO.RUN faster // only using FPU?
Begin
  SumOfRatio[i] := SumOfRatio[i-1] + (extended(1.0)*CntZero(pMul,Lmt))/GetCoD(pMul,Lmt);
end;

function MulByI(pMul:tpMul;UL,i :NativeInt):NativeInt;
var
  prod  : Uint64;
  j     : nativeInt;
  carry : LongWord;
begin
  result := UL;
  carry := 0;
  For j := 0 to result do
  Begin
    prod  := i*pMul[0]+Carry;
    Carry := prod Div LongWordDec;
    pMul[0] := Prod - LongWordDec*Carry;
    inc(pMul);
  end;

  IF Carry <> 0 then
  Begin
    inc(result);
    pMul[0]:= Carry;
  End;
end;

procedure getFactorialExact(n:NativeInt);
var
  MulArr : tMul;
  pMul : tpMul;
  i,ul : NativeInt;
begin
  i := getFactorialDecDigits(n) DIV 9 +10;
  Setlength(MulArr,i);
  pMul := @MulArr[0];
  Ul := 0;
  pMul[Ul]:= 1;
  i := 1;
  repeat
    UL := MulByI(pMul,UL,i);
    //Now do what you like to do with i!
    DoChecks(pMul,UL,i);
    inc(i);
  until i> n;
end;

procedure Out_(i: integer);
begin
  if i > LIMIT then
    EXIT;
  writeln(i:8,SumOfRatio[i]/i:18:15);
end;

var
  i : integer;
Begin
  InitCoZ;
  SumOfRatio[0]:= 0;
  getFactorialExact(LIMIT);
  Out_(100);
  Out_(1000);
  Out_(10000);
  Out_(50000);
  i := limit;
  while i >0 do
  Begin
    if SumOfRatio[i]/i >0.16 then
      break;
    dec(i);
  end;
  inc(i);
  writeln('First ratio < 0.16 ', i:8,SumOfRatio[i]/i:20:17);
end.
