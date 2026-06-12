program K_pow_K_gmp;
//First occurence of a numberstring with max DIGTIS digits in k^k
{$IFDEF FPC}
  {$MODE DELPHI}
  {$Optimization ON,ALL}
{$ELSE}
   {$APPTYPE CONSOLE}
{$ENDIF}

uses
  sysutils,gmp;
const
 LongWordDec = 1000*1000*1000;

 Digits = 7;

var
  Pot_N_str : AnsiString;
  Str_Found : array of Uint32;
  FirstMissing :NativeInt;
  T0 : INt64;

procedure Out_Results(number,found:NativeInt);
var
  i : NativeInt;
Begin
  writeln;
  writeln(#10,'Found: ',found,' at ',number,' with ',length(pChar(Pot_N_str)),
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

function CheckOneString(const s:Ansistring;lmt,pow:NativeInt):NativeInt;
//check every possible number from one to DIGITS digits
var
  i,k,num : NativeInt;
begin
  result := 0;

  For i := 1 to lmt do
  Begin
    k := i;
    num := 0;
    repeat
      num := num*10+ Ord(s[k])-Ord('0');
      IF (num >= FirstMissing) AND (str_Found[num] = 0) then
      begin
        str_Found[num]:= pow+1;
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
  zkk: mpz_t;
  number,i,found,lenS,decLimit: Int32;
Begin
  T0 := GetTickCount64;
  mpz_init(zkk);

  decLimit := 1;
  For i := 1 to digits do
    decLimit *= 10;
  setlength(Str_Found,decLimit);

  //calc digits for max number := 10000
  number:= 10000;
  i := trunc(number*ln(number)/ln(10))+5;
  setlength(Pot_N_str,i);

  found := 0;
  FirstMissing := 0;
  number := 1;
  lenS :=1;
  repeat
    mpz_ui_pow_ui(zkk,number,number);
    mpz_get_str(pChar(Pot_N_str),10,zkk);
    while Pot_N_str[lenS] <> #0 do inc(lenS);
//      lenS := length(pChar(Pot_N_str));
    inc(found,CheckOneString(Pot_N_str,lenS,number));
    inc(number);
    if number AND 511 = 0 then
      write(#13,number:7,' with ',lenS, ' digits.Found ',found);
  until number>9604;// found >=decLimit;
  Out_Results(number,found);
end.
