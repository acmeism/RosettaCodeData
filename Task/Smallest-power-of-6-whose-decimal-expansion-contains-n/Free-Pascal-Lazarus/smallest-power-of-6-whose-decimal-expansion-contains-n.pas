program PotOf6;
//First occurence of a numberstring with max decimal DIGTIS digits in 6^n
{$IFDEF FPC}
  {$MODE DELPHI} {$Optimization ON,ALL} {$COPERATORS ON}{$CODEALIGN proc=16}
{$ENDIF}
{$IFDEF WINDOWS}
   {$APPTYPE CONSOLE}
{$ENDIF}

uses
  sysutils;
const
  //decimal places used by multiplication and for string  conversion
  calcDigits = 8;
  PowerBase  = 6;  // don't use 10^n  ;-)

// for PowerBase = 2 maxvalues for POT_LIMIT and STRCOUNT
// DIGITS = 8;decLimit= 100*1000*1000;POT_LIMIT = 114715;STRCOUNT = 83789;
 DIGITS = 7;decLimit=  10*1000*1000;POT_LIMIT =  32804;STRCOUNT = 24960;
// DIGITS = 6;decLimit=     1000*1000;POT_LIMIT =   9112;STRCOUNT =  7348;
// DIGITS = 5;decLimit=      100*1000;POT_LIMIT =   2750;STRCOUNT =  2148;
// DIGITS = 4;decLimit=       10*1000;POT_LIMIT =    809;STRCOUNT =   616;
// DIGITS = 3;decLimit=          1000;POT_LIMIT =    215;STRCOUNT =   175;
// DIGITS = 2;decLimit=           100;POT_LIMIT =     66;STRCOUNT =    45;

type
  tMulElem = Uint32;
  tMul = array of tMulElem;
  tpMul = pUint32;
  tPotArrN = array[0..1] of tMul;

  tFound = record
             foundIndex,
             foundStrIdx : Uint32;
           end;
var
{$ALIGN 32}
  PotArrN   : tPotArrN;
  StrDec4Dgts  : array[0..9999] of String[4];
  Str_Found : array of tFound;
  FoundString : array of AnsiString;
  CheckedNum : array of boolean;
  Pot_N_str : AnsiString;
  FirstMissing,
  FoundIdx :NativeInt;
  T0 : INt64;

procedure Init_StrDec4Dgts;
var
  s : string[4];
  i : integer;
  a,b,c,d : char;
begin
  i := 0;
  s := '0000';
  For a := '0' to '9' do
  Begin
    s[1] := a;
    For b := '0' to '9' do
    begin
      s[2]:=b;
      For c := '0' to '9' do
      begin
        s[3] := c;
        For d := '0' to '9' do
        begin
          s[4] := d;
          StrDec4Dgts[i]:= s;
          inc(i);
        end;
      end;
    end;
  end;
end;

function Commatize(const s: AnsiString):AnsiString;
var
   fromIdx,toIdx :Int32;
Begin
  result := '';
  fromIdx := length(s);
  toIdx := fromIdx-1;
  if toIdx < 3 then
  Begin
    result := s;
    exit;
  end;
  toIdx := 4*(toIdx DIV 3)+toIdx MOD 3 +1 ;
  setlength(result,toIdx);
  repeat
    result[toIdx]   := s[FromIdx];
    result[toIdx-1] := s[FromIdx-1];
    result[toIdx-2] := s[FromIdx-2];
    result[toIdx-3] := ',';
    dec(toIdx,4);
    dec(FromIdx,3);
  until FromIdx<=3;
  while fromIdx>=1 do
  Begin
    result[toIdx] := s[FromIdx];
    dec(toIdx);
    dec(fromIdx);
  end;
end;

procedure Init_Mul(number:NativeInt);
var
  dgtCount,
  MaxMulIdx : NativeInt;
Begin
  dgtCount := trunc(POT_LIMIT*ln(number)/ln(10))+1;
  MaxMulIdx := dgtCount DIV calcDigits +2;
  setlength(PotArrN[0],MaxMulIdx);
  setlength(PotArrN[1],MaxMulIdx);
  PotArrN[0,0] := 1;
  setlength(Pot_N_str,dgtCount);
end;

function Mul_PowerBase(var Mul1,Mul2:tMul;limit:Uint32):NativeInt;
//Mul2 = n*Mul1. n must be < LongWordDec !
const
  LongWordDec = 100*1000*1000;
var
  pM1,pM2 : tpMul;
  carry,prod : Uint64;
begin
  pM1 := @Mul1[0];
  pM2 := @Mul2[0];
  carry := 0;
  result :=0;
  repeat
    prod  := PowerBase*pM1[result]+Carry;
    Carry := prod Div LongWordDec;
    pM2[result] := Prod - Carry*LongWordDec;
    inc(result);
  until result > limit;
  IF Carry <> 0 then
    pM2[result] := Carry
  else
    dec(result);
end;

procedure ConvToStr(var s:Ansistring;const Mul:tMul;i:NativeInt);
var
  s8: string[calcDigits];
  pS : pChar;
  j,k,d,m : NativeInt;
begin
  j := (i+1)*calcDigits;
  setlength(s,j+1);
  pS := @s[1];
  m := Mul[i];
  str(Mul[i],s8);
  j := length(s8);
  move(s8[1],pS[0],j);
  k := j;
  dec(i);
  If i >= 0 then
    repeat
      m := MUL[i];
      d := m div 10000;
      m := m-10000*d;
      move(StrDec4Dgts[d][1],pS[k],4);
      move(StrDec4Dgts[m][1],pS[k+4],4);
      inc(k,calcDigits);
      dec(i);
    until i<0;
  setlength(s,k);
end;

function CheckOneString(const s:Ansistring;pow:NativeInt):NativeInt;
//check every possible number from one to DIGITS digits,
//if it is still missing in the list
var
  pChecked : pBoolean;
  i,k,lmt,num : NativeInt;
  oneFound : boolean;
begin
  pChecked := @CheckedNum[0];
  result := 0;
  oneFound := false;
  lmt := length(s);
  For i := 1 to lmt do
  Begin
    k := i;
    num := 0;
    repeat
      num := num*10+ Ord(s[k])-Ord('0');
      IF (num >= FirstMissing) AND Not(pChecked[num]) then
      begin
        //memorize that string commatized
        if NOT(oneFound) then
        Begin
          oneFound := true;
          FoundString[FoundIDX] := Commatize(s);
          FoundIDX  += 1;
        end;
        pChecked[num]:= true;
        with str_Found[num] do
        Begin
          foundIndex:= pow+1;
          foundStrIdx:= FoundIDX-1;
        end;
        inc(result);
        if num =FirstMissing then
          repeat
            inc(FirstMissing)
          until str_Found[FirstMissing].foundIndex =0;
      end;
      inc(k)
    until (k>lmt) or (k-i >DIGITS-1);
  end;
end;

var
  i,j,k,toggle,MaxMulIdx,found: Int32;
Begin
  T0 := GetTickCount64;
  setlength(Str_Found,decLimit);
  setlength(CheckedNum,decLimit);
  setlength(FoundString,STRCOUNT);
  FirstMissing := 0;
  FoundIdx  := 0;
  Init_StrDec4Dgts;
  Init_Mul(PowerBase);
  writeln('Init in ',(GetTickCount64-T0)/1000:8:3,' secs');
  T0 := GetTickCount64;
  toggle := 0;
  found := 0;
  MaxMulIdx := 0;
  k := 0;
  For j := 0 to POT_LIMIT do
  Begin
//    if j MOD 20 = 0 then  writeln;
    ConvToStr(Pot_N_str,PotArrN[toggle],MaxMulIdx);
    i := CheckOneString(Pot_N_str,j);
    found += i;
    if i <> 0 then
      k += 1;
    MaxMulIdx := Mul_PowerBase(PotArrN[toggle],PotArrN[1-toggle],MaxMulIdx);
    toggle := 1-toggle;

    if FirstMissing = decLimit then
    Begin
      writeln(#10,'Max power ',j,' with ',length(Pot_N_str),' digits');
      break;
    end;
//    if (j and 1023) = 0 then     write(#13,j:10,found:10,FirstMissing:10);
  end;
  writeln(#13#10,'Found: ',found,' in ',k,' strings. Time used ',(GetTickCount64-T0)/1000:8:3,' secs');
  For i := 0 to 22 do//decLimit-1 do
    with Str_Found[i] do
       writeln(i:10,' ',PowerBase,'^',foundIndex-1:5,' ',(FoundString[foundStrIdx]):30);
end.
