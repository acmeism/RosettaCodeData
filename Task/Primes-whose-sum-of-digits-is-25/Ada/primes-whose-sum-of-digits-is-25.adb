-- Rosetta Code Task written in Ada
-- Primes whose sum of digits is 25
-- https://rosettacode.org/wiki/Primes_whose_sum_of_digits_is_25
-- November 2024, R. B. E.

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Primes_Whose_Sum_of_Digits_is_25 is

  Max_Prime_Candidate : constant Positive := 5_000; -- per task description

  function Is_Prime (N : in Natural) return Boolean is
    Temp : Natural := 5;
  begin
    if N < 2 then
      return False;
    end if;
    if N mod 2 = 0 then
      return N = 2;
    end if;
    if N mod 3 = 0 then
      return N = 3;
    end if;
    while Temp * Temp <= N loop
      if N mod Temp = 0 then
        return False;
      end if;
      Temp := Temp + 2;
      if N mod Temp = 0 then
        return False;
      end if;
    end loop;
    return True;
  end Is_Prime;

  function Is_Sum_of_Digits_Equal_to_25 (N : Positive) return Boolean is
    Local_N : Natural := N;
    Sum : Natural := 0;
    Current_Remainder : Natural;
  begin
    while Local_N > 0 loop
      Current_Remainder := Local_N mod 10;
      Sum := Sum + Current_Remainder;
      Local_N := Local_N / 10;
    end loop;
  return Sum = 25;
  end Is_Sum_of_Digits_Equal_to_25;

  Prime_Count : Natural := 0;

begin
  for I in 1..Max_Prime_Candidate loop
    if Is_Sum_of_Digits_Equal_to_25 (I) then
      if (Is_Prime (I)) then
        Prime_Count := Prime_Count + 1;
        Put (I, 0);
        Put (" ");
      end if;
    end if;
  end loop;
  New_Line;
  Put ("There are ");
  Put (Prime_Count, 0);
  Put (" primes less than ");
  Put (Max_Prime_Candidate, 0);
  Put_Line (" whose sum of digits is 25");
end Primes_Whose_Sum_of_Digits_is_25;

