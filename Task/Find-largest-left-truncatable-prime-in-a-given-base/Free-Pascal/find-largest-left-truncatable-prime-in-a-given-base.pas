program TruncatablePrimes;
//https://rosettacode.org/wiki/Find_largest_left_truncatable_prime_in_a_given_base
{$IFDEF FPC}{$MODE DELPHI}{$OPTIMIZATION ON,ALL}{$ENDIF}
{$IFDEF Windows}{$APPTYPE CONSOLE}{$ENDIF}
uses
  sysutils,gmp;// http://rosettacode.org/wiki/Extensible_prime_generator#Pascal
const
  DgtToChar : array[0..10+26+26-1] of char =
  '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz';
  MaxDgtCnt = 50;
var
  pot_Base : array[0..MaxDgtCnt] of mpz_t;
  Numbers  : array[0..MaxDgtCnt] of mpz_t;
  MAX_Found  : mpz_t;
  Digits,
  Digits_Found: array[0..MaxDgtCnt] of byte;
  gbl_Count,
  Max_Pot : Uint32;

procedure InitAll;
var
  pot : mpz_t;
  MaxBase,
  i : integer;
begin
  MaxBase := MaxDgtCnt;
  mpz_init_set_ui(pot,1);
  For i := 0 to High(pot_Base) do
  begin
    mpz_mul_ui(pot,pot,MaxBase);
    mpz_init_set(pot_Base[i],Pot);
    mpz_init_set(Numbers[i],Pot);
  end;
  mpz_init_set(MAX_Found,pot);
  mpz_set_ui(MAX_Found,0);
  mpz_clear(pot);
end;

procedure ClearAll;
var
  i : integer;
begin
  For i := High(pot_Base) downto 0  do
  begin
    mpz_clear(pot_Base[i]);
    mpz_clear(Numbers[i]);
  end;
  mpz_clear(MAX_Found);
end;

procedure InitPot(Base : byte);
var
  pot : mpz_t;
  i : integer;
begin
  mpz_init_set_ui(pot,1);
  For i := 0 to High(pot_Base) do
  begin
    mpz_set(pot_Base[i],Pot);
    mpz_mul_ui(pot,pot,base);
  end;
  mpz_clear(pot);
  mpz_set_ui(MAX_Found,0);
  Fillchar(Digits,SizeOf(Digits),#0);
end;

procedure Next_Number(Base,pot : byte);
var
  i : integer;
begin
  inc(gbl_Count);
  if pot = 0 then
    mpz_set_ui(Numbers[pot],0)
  else
    mpz_set(Numbers[pot],Numbers[pot-1]);
  For i := 1 to Base-1 do
  begin
    Digits[pot] := i;
    mpz_add(Numbers[pot],Numbers[pot],pot_Base[pot]);
    if mpz_probab_prime_p(Numbers[pot],5)>0 then
    Begin
      IF mpz_cmp(MAX_Found,Numbers[pot])<0 then
      Begin
        mpz_set(Max_Found,Numbers[pot]);
        Max_pot := pot;
        Digits_Found := Digits;
      end;
      Next_Number(Base,pot+1);
    end;
  end;
end;

var
  base,i : NativeUint;
  sol : pChar;
Begin
  GetMem(sol,10000);
  InitAll;
  try
  For base := 3 to 31 do
  begin
    IF (Base>17) AND Not(Odd(Base)) then
      continue;
    InitPot(base);
    gbl_Count := 0;
    write('Base ',base:2,' digits ');
    Next_Number(base,0);
    write(Max_Pot+1:4,' checks ',gbl_Count:8,' ');
    if mpz_fits_ulong_p(Max_Found)<> 0 then
      write(mpz_get_ui(Max_Found),'  ')
    else
    Begin
      mpz_get_str(Sol,10,Max_Found);
      write(Sol,'  ');
    end;
    For i := Max_Pot downto 0 do
      write(DgtToChar[Digits_Found[i]]);
    writeln;
  end;
  except
    ClearAll;
  end;
  ClearAll;
  FreeMem(sol);
end.
