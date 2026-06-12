program K_pow_K;
//First occurence of a numberstring with max DIGTIS digits in k^k
{$IFDEF FPC}
  {$MODE DELPHI}
  {$Optimization ON,ALL}
{$ELSE}
   {$APPTYPE CONSOLE}
{$ENDIF}

uses
  sysutils;
const
 LongWordDec = 1000*1000*1000;
 Digits = 6;

type
  tMulElem = Uint32;
  tMul = array of tMulElem;
  tpMul = pUint32;
  tFound =  Uint32;
var
  Pot_N_str : AnsiString;
  Str_Found : array of tFound;
  FirstMissing :NativeInt;
  T0 : INt64;

procedure Out_Results(number,found:NativeInt);
var
  i : NativeInt;
Begin
  writeln;
  writeln(#10,'Found: ',found,' at ',number,' with ',length(Pot_N_str),
     ' digits in Time used ',(GetTickCount64-T0)/1000:8:3,' secs');
  writeln ;
  writeln('               0    1    2    3    4    5    6    7    8    9');
  write('          |__________________________________________________');
  For i := 0 to 99 do//decLimit-1 do
  begin
    if i MOD 10 = 0 then
    Begin
      writeln;
      write((i DIV 10)*10:10,'|');
    end;
    number := Str_Found[i]-1;
    if number > 0 then
        write(number:5);
  end;
  writeln;
end;

procedure Mul_12(var Mul1,Mul2:tMul);
//Mul2 = Mul1*Mul2;
var
  TmpMul : tMul;
  carry,
  n,prod: Uint64;
  lmt1,lmt2,i,j : NativeInt;
begin
  lmt1 := High(MUl1);
  lmt2 := High(Mul2);
  setlength(TmpMul,lmt1+lmt2+3);
  For i := 0 to lmt1 do
  Begin
    carry := 0;
    n := Mul1[i];
    For j := 0 to lmt2 do
    Begin
      prod := n*Mul2[j]+TmpMul[i+j]+carry;
      carry := prod DIV LongWordDec;
      TmpMul[i+j]:=prod-carry*LongWordDec;
    end;
    TmpMul[i+lmt2+1] += carry;
  end;
  Mul2 := TmpMul;
  setlength(TmpMul,0);
  i := High(Mul2);
  while (i>=1) AND (Mul2[i]=0) do
    dec(i);
  setlength(Mul2,i+1);
end;

procedure ConvToStr(var s:Ansistring;const Mul:tMul;i:NativeInt);
var
  s9: string[9];
  pS : pChar;
  j,k : NativeInt;
begin
//  i := High(MUL);
  j := (i+1)*9;
  setlength(s,j+1);
  pS := pChar(s);
  // fill complete with '0'
  fillchar(pS[0],j,'0');
  str(Mul[i],S9);
  j := length(s9);
  move(s9[1],pS[0],j);
  k := j;
  dec(i);
  If i >= 0 then
    repeat
      str(Mul[i],S9);// no leading '0'
      j := length(s9);
      inc(k,9);
      //move to the right place, leading '0' is already there
      move(s9[1],pS[k-j],j);
      dec(i);
    until i<0;
  setlength(s,k);
end;

function CheckOneString(const s:Ansistring;pow:NativeInt):NativeInt;
//check every possible number from one to DIGITS digits
var
  i,k,lmt,num : NativeInt;
begin
  result := 0;

  lmt := length(s);
  For i := 1 to lmt do
  Begin
    k := i;
    num := 0;
    repeat
      num := num*10+ Ord(s[k])-Ord('0');
      IF (num >= FirstMissing) AND (str_Found[num] = 0) then
      begin
        str_Found[num]:= pow+1;
        // commatize only once. reference counted string
        inc(result);
        if num =FirstMissing then
        Begin
          while str_Found[FirstMissing] <> 0 do
            inc(FirstMissing);
        end;
      end;
      inc(k)
    until (k>lmt) or (k-i >DIGITS-1);
  end;
end;

var
  MulErg,Square :tMUl;
  number,i,j,found,decLimit: Int32;
Begin
  T0 := GetTickCount64;
  decLimit := 1;
  For i := 1 to digits do
    decLimit *= 10;
  setlength(Str_Found,decLimit);

  found := 0;
  FirstMissing := 0;
  number := 1;
  repeat
    setlength(MulErg,1);
    MulErg[0] := 1;
    setlength(Square,1);
    Square[0]:= number;

    If number AND 1 <> 0 then
      MulErg[0] := number;
    j := 2;
    while j <= number do
    Begin
      Mul_12(Square,Square);
      If number AND J <> 0 then
        Mul_12(Square,MulErg);
      j:= j*2;
    end;
    ConvToStr(Pot_N_str,MulErg,High(MulErg));
    inc(found,CheckOneString(Pot_N_str,number));
    inc(number);
    if number AND 511 = 0 then
      write(#13,number:7,' with ',length(Pot_N_str), ' digits.Found ',found);
  until found >=decLimit;
  Out_Results(number,found);
end.
