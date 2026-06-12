-- Rosetta Code Task written in Ada
-- Quadrat special primes
-- https://rosettacode.org/wiki/Quadrat_special_primes
-- Translated from the AWK solution
-- April 2025, R. B. E.

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;

procedure Quadrat_Special_Primes is

  function Is_Prime (X : Positive) return Boolean is
  begin
    if (X < 2) then
      return False;
    end if;
    for I in 2..Integer (Float'Truncation (sqrt (Float (X)))) loop
      if ((X mod I) = 0) then
        return False;
      end if;
    end loop;
    return True;
  end Is_Prime;

  Max : constant Positive := 16_000;
  P : Positive := 2;
  J : Positive := 1;
  Count : Natural := 0;

begin
  New_Line;
  Put ("Quadrat special primes < ");
  Put (Max, 0);
  Put_Line (":");
  Put (P, 6);
  Count := Count + 1;
  OUTER: loop
    INNER: loop
      exit INNER when (Is_Prime (P + (J * J)));
      J := J + 1;
    end loop INNER;
    P := P + (J * J);
    exit OUTER when P >= Max;
    Put (P, 6);
    Count := Count + 1;
    if ((Count mod 7) = 0) then
      New_Line;
    end if;
    J := 1;
  end loop OUTER;
  New_Line;
end Quadrat_Special_Primes;

