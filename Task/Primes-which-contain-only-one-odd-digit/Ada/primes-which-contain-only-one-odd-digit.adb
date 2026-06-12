-- Rosetta Code Task written in Ada
-- Primes which contain only one odd digit
-- https://rosettacode.org/wiki/Primes_which_contain_only_one_odd_digit
-- May 2026, R. B. E.

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Primes_Which_Contain_Only_One_Odd_Digit is

  function Contains_One_Odd_Digit (Candidate : Natural) return Boolean is
    X : Natural := Candidate;
    Current_Digit : Natural;
    Odd_Digit_Count : Natural := 0;
  begin
    while (X > 0) loop
      Current_Digit := X mod 10;
      if ((Current_Digit mod 2) /= 0) then
        Odd_Digit_Count := Odd_Digit_Count + 1;
      end if;
      X := X / 10;
    end loop;
    if (Odd_Digit_Count = 1) then
      return True;
    else
      return False;
    end if;
  end Contains_One_Odd_Digit;

  function Is_Prime (P : Positive) return Boolean is
    D : Positive := 5;
  begin
    if (P < 2) then
      return False;
    end if;
    if ((P mod 2) = 0) then
      return (P = 2);
    end if;
    if ((P mod 3) = 0) then
      return (P = 3);
    end if;
    while ((D * D) <= P) loop
      if ((P mod D) = 0) then
        return False;
      end if;
      D := D + 2;
    end loop;
    return True;
  end Is_Prime;

  How_Many : Natural;

begin
  How_Many := 0;
  Put_Line ("These are the prime numbers with only one odd digit below 1000:");
  for I in 2..1_000 loop
    if (Is_Prime (I) and Contains_One_Odd_Digit (I)) then
      How_Many := How_Many + 1;
      Put (I, 4);
      if ((How_Many mod 9) = 0) then
        New_Line;
      end if;
    end if;
  end loop;
  Put ("There are ");
  Put (How_Many, 0);
  Put_Line (" primes with only one odd digit below 1000.");
  How_Many := 0;
  for I in 2..1_000_000 loop
    if (Is_Prime (I) and Contains_One_Odd_Digit (I)) then
      How_Many := How_Many + 1;
    end if;
  end loop;
  New_Line;
  Put ("Found ");
  Put (How_Many, 0);
  Put_Line (" primes with only one odd digit below 1_000_000.");
  New_Line;
end Primes_Which_Contain_Only_One_Odd_Digit;
