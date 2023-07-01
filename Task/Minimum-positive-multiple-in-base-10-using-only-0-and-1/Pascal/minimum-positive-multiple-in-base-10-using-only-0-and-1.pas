program B10_num;
//numbers having only digits 0 and 1 in their decimal representation
//see https://oeis.org/A004290
//Limit of n= 2^19

{$IFDEF FPC} //fpc 3.0.4
  {$MODE DELPHI}  {$OPTIMIZATION ON,ALL} {$codealign proc=16}
{$ELSE}
  {$APPTYPE CONSOLE}
{$ENDIF}
uses
  sysutils,gmp; //Format
const
  Limit  = 256*256*8;//8+8+3 Bits aka 19 digits
  B10_4  = 10*10*10*10;
  B10_5  = 10*B10_4;
  B10_9  = B10_5*B10_4;
  HexB10 : array[0..15] of NativeUint = (0000,0001,0010,0011,0100,0101,0110,0111,
                                         1000,1001,1010,1011,1100,1101,1110,1111);
var
  ModToIdx  : array[0..Limit] of Int32;
  B10ModN : array[0..limit-1] of Uint32;
  B10 : array of Uint64;

procedure OutOfRange(n:NativeUint);
Begin
  Writeln(n:7,' -- out of range --');
end;

function ConvB10(n: Uint32):Uint64;
//Convert n from binary as if it is Base 10
//limited for Uint64 to 2^20-1= 1048575 ala 19 digits
var
  fac_B10 : Uint64;
Begin
  fac_B10 := 1;
  result := 0;
  repeat
    result += fac_B10*HexB10[n AND 15];
    n := n DIV 16;
    fac_B10 *=B10_4;
  until n = 0;
end;

procedure InitB10;
var
  i : NativeUint;
Begin
  setlength(B10,Limit);
  For i := 0 to Limit do
    b10[i]:= ConvB10(i);
end;

procedure Out_Big(n,h,l:NativeUint);
var
  num,rest : MPInteger;
Begin
  //For Windows gmp ui is Uint32 :-(
  z_init_set_ui(num,Hi(B10[h]));
  z_mul_2exp(num,num,32);
  z_add_ui(num,num,Lo(B10[h]));
  z_mul_ui(num,num,B10_5);z_mul_ui(num,num,B10_5);
  z_mul_ui(num,num,B10_5);z_mul_ui(num,num,B10_4);

  z_init_set_ui(rest,Hi(B10[l]));
  z_mul_2exp(rest,rest,32);
  z_add_ui(rest,rest,Lo(B10[l]));
  z_add(num,num,rest);
  write(Format('%7d %19u%.19u ',[n,B10[h],B10[l]]));
  IF z_divisible_ui_p(num,n) then
  Begin
    z_cdiv_q_ui(num, num,n);
    write(z_get_str(10,num));
  end;
  writeln;
  z_clear(rest);
  z_clear(num);
end;

procedure Out_Small(i,n: NativeUint);
var
  value,Mul : Uint64;
Begin
  value := B10[i];
  mul := value div n;
  IF mul = 1 then
    mul := n;
  writeln(n:7,value:39,' ',mul);
end;

procedure CheckBig_B10(n:NativeUint);
var
  h,BigMod,h_mod:NativeUint;
  l : NativeInt;
Begin
  BigMod :=(sqr(B10_9)*10) MOD n;
  For h := Low(B10ModN)+1 to High(B10ModN) do
  Begin
    //h_mod+l_mod == n =>  n- h_mod = l_mod
    h_mod := n-(BigMod*B10ModN[h])MOD n;
    l := ModToIdx[h_mod];
    if l>= 0 then
    Begin
      Out_Big(n,h,l);
      EXIT;
    end;
  end;
  OutOfRange(n);
end;

procedure Check_B10(n:NativeUint);
var
  pB10 : pUint64;
  i,value : NativeUint;
begin
  B10ModN[0] := 0;
  //set all modulus n  => 0..N-1 to -1
  fillchar(ModToIdx,n*SizeOf(ModToIdx[0]),#255);
  ModToIdx[0] := 0;
  pB10 := @B10[0];
  i := 1;
  repeat
    value := Uint64(pB10[i]) MOD n;
    If value = 0 then
      Break;
    B10ModN[i] := value;
    //memorize the first occurrence
    if ModToIdx[value] < 0 then
      ModToIdx[value]:= i;
    inc(i);
  until i > High(B10ModN);
  IF i < High(B10ModN) then
    Out_Small(i,n)
  else
    CheckBig_B10(n);
end;

var
  n : Uint32;
Begin
  InitB10;
  writeln('Number':7,'B10':39,' Multiplier');
  For n := 1 to 10 do
    Check_B10(n);
  For n := 95 to 105 do
    Check_B10(n);

  Check_B10(297);  Check_B10(576);  Check_B10(891);  Check_B10(909);
  Check_B10( 999);  Check_B10(1998);  Check_B10(2079);  Check_B10(2251);
  Check_B10(2277);  Check_B10(2439);  Check_B10(2997);  Check_B10(4878);
  check_B10(9999);
  check_B10(2*9999); //real 0m0,077s :-)
end.
