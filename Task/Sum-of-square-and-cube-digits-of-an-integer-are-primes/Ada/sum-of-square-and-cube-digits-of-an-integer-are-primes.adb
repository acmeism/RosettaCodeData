-- Rosetta Code Task written in Ada
-- Sum of square and cube digits of an integer are primes
-- https://rosettacode.org/wiki/Sum_of_square_and_cube_digits_of_an_integer_are_primes
-- Loosely translated from the Nim solution
-- March 2025, R. B. E.

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Sum_of_Square_and_Cube_Digits_of_an_Integer_are_Primes is

  function Is_Prime (Candidate : in Positive) return Boolean is
    type Prime_Sieve_Array is array (Positive range <>) of Positive;
    Prime_Sieve : Prime_Sieve_Array := (2, 3, 5, 7, 11, 13, 17, 19);
  begin
    for J in Prime_Sieve'Range loop
      if Candidate = Prime_Sieve (J) then
        return True;
      end if;
    end loop;
    return False;
  end Is_Prime;

  function Sum_of_Digits (N : in Positive) return Positive is
    Local_N : Natural := N;
    Result : Natural := 0;
  begin
    while Local_N > 0 loop
      Result := Result + Local_N mod 10;
      Local_N := Local_N / 10;
    end loop;
    return Result;
  end Sum_of_Digits;

  N_Squared, N_Cubed : Positive;
  Sum_of_the_Squared_Digits : Positive;
  Sum_of_the_Cubed_Digits : Positive;

begin
  for I in 5..99 loop
    N_Squared := I * I;
    N_Cubed := N_Squared * I;
    Sum_of_the_Squared_Digits := Sum_of_Digits (N_Squared);
    Sum_of_the_Cubed_Digits := Sum_of_Digits (N_Cubed);
    if ((Is_Prime (Sum_of_Digits (N_Squared))) and (Is_Prime (Sum_of_Digits (N_Cubed)))) then
      Put (I, 0);
      Put (" ");
    end if;
  end loop;
  New_Line;
end Sum_of_Square_and_Cube_Digits_of_an_Integer_are_Primes;

