-- Rosetta Code Task written in Ada
-- Safe and Sophie Germain primes
-- https://rosettacode.org/wiki/Safe_and_Sophie_Germain_primes
-- Translated from the AWK solution
-- April 2025, R. B. E.

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Safe_And_Sophie_Germain_Primes is

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

  Limit : constant Positive := 50;
  Count : Natural := 0;
  Candidate : Positive := 1;

begin
  Put ("The first ");
  Put (Limit, 0);
  Put_Line (" Sophie Germain primes:");
  while (Count < Limit) loop
    Candidate := Candidate + 1;
    if (Is_Prime (Candidate)) then
      if (Is_Prime ((Candidate * 2) + 1)) then
        Put (Candidate, 5);
        Count := Count + 1;
        if ((Count mod 10) = 0) then
          New_Line;
        end if;
      end if;
    end if;
  end loop;
end Safe_And_Sophie_Germain_Primes;
