program CircularPrimes;
//nearly the way it is done:
//http://www.worldofnumbers.com/circular.htm
//base 4 counter to create numbers with first digit is the samallest used.
//check if numbers are tested before and reduce gmp-calls by checking with prime 3,7

{$IFDEF FPC}
  {$MODE DELPHI}{$OPTIMIZATION ON,ALL}
  uses
    Sysutils,gmp;
{$ENDIF}
{$IFDEF Delphi}
  uses
    System.Sysutils,?gmp?;
{$ENDIF}

{$IFDEF WINDOWS}
   {$APPTYPE CONSOLE}
{$ENDIF}
const
  MAXCNTOFDIGITS = 14;
  MAXDGTVAL = 3;
  conv : array[0..MAXDGTVAL+1] of byte = (9,7,3,1,0);
type
  tDigits = array[0..23] of byte;
  tUint64 = NativeUint;
var
  mpz : mpz_t;
  digits,
  revDigits : tDigits;
  CheckNum : array[0..19] of tUint64;
  Found : array[0..23] of tUint64;
  Pot_ten,Count,CountNumCyc,CountNumPrmTst : tUint64;

procedure CheckOne(MaxIdx:integer);
var
  Num : Uint64;
  i : integer;
begin
  i:= MaxIdx;
  repeat
    inc(CountNumPrmTst);
    num := CheckNum[i];
    mpz_set_ui(mpz,Num);
    If mpz_probab_prime_p(mpz,3)=0then
      EXIT;
    dec(i);
  until i < 0;
  Found[Count] := CheckNum[0];
  inc(count);
end;

function CycleNum(MaxIdx:integer):Boolean;
//first create circular numbers to minimize prime checks
var
  cycNum,First,P10 : tUint64;
  i,j,cv : integer;
Begin
  i:= MaxIdx;
  j := 0;
  First := 0;
  repeat
    cv := conv[digits[i]];
    dec(i);
    First := First*10+cv;
    revDigits[j]:= cv;
    inc(j);
  until i < 0;
  // if num is divisible by 3 then cycle numbers also divisible by 3 same sum of digits
  IF First MOD 3 = 0 then
    EXIT(false);
  If First mod 7 = 0 then
     EXIT(false);

  //if one of the cycled number must have been tested before break
  P10 := Pot_ten;
  i := 0;
  j := 0;
  CheckNum[j] := First;
  cycNum := First;
  repeat
    inc(CountNumCyc);
    cv := revDigits[i];
    inc(j);
    cycNum := (cycNum - cv*P10)*10+cv;
    //num was checked before
    if cycNum < First then
      EXIT(false);
    if cycNum mod 7 = 0 then
      EXIT(false);
    CheckNum[j] := cycNum;
    inc(i);
  until i >= MaxIdx;
  EXIT(true);
end;

var
  T0: Int64;

  idx,MaxIDx,dgt,MinDgt : NativeInt;
begin
  T0 := GetTickCount64;
  mpz_init(mpz);

  fillchar(digits,Sizeof(digits),chr(MAXDGTVAL));
  Count :=0;
  For maxIdx := 2 to 10 do
    if maxidx in[2,3,5,7] then
    begin
      Found[Count]:= maxIdx;
      inc(count);
    end;

  Pot_ten := 10;
  maxIdx := 1;
  idx := 0;
  MinDgt := MAXDGTVAL;
  repeat
    if CycleNum(MaxIdx) then
        CheckOne(MaxIdx);
    idx := 0;
    repeat
      dgt := digits[idx]-1;
      if dgt >=0 then
        break;
      digits[idx] := MinDgt;
      inc(idx);
    until idx >MAXCNTOFDIGITS-1;

    if idx > MAXCNTOFDIGITS-1 then
      BREAK;

    if idx<=MaxIDX then
    begin
      digits[idx] := dgt;
      //change all to leading digit
      if idx=MaxIDX then
      Begin
        For MinDgt := 0 to idx do
          digits[MinDgt]:= dgt;
        minDgt := dgt;
      end;
    end
    else
    begin
      minDgt := MAXDGTVAL;
      For maxidx := 0 to idx do
        digits[MaxIdx] := MAXDGTVAL;
      Maxidx := idx;
      Pot_ten := Pot_ten*10;
      writeln(idx:7,count:7,CountNumCyc:16,CountNumPrmTst:12,GetTickCount64-T0:8);
    end;
  until false;
  writeln(idx:7,count:7,CountNumCyc:16,CountNumPrmTst:12,GetTickCount64-T0:8);
  T0 := GetTickCount64-T0;

  For idx := 0 to count-2 do
    write(Found[idx],',');
  writeln(Found[count-1]);

  writeln('It took ',T0,' ms ','to check ',MAXCNTOFDIGITS,' decimals');
  mpz_clear(mpz);
  {$IFDEF WINDOWS}
   readln;
  {$ENDIF}
end.
