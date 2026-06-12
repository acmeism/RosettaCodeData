-- Rosetta Code Task written in Ada
-- Largest difference between adjacent primes
-- https://rosettacode.org/wiki/Largest_difference_between_adjacent_primes
-- Loosely translated from the AWK solution
-- June 2025, R. B. E.

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Largest_Difference_Between_Adjacent_Primes is

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

  function Next_Prime (P : Positive) return Positive is
    Q : Positive := P;
  begin
    if (Q = 0) then
      return 2;
    end if;
    if (Q < 3) then
      Q := Q + 1;
      return Q;
    end if;
    q := P + 2;
    while (not (Is_Prime (Q))) loop
      Q := Q + 2;
    end loop;
    return Q;
  end Next_Prime;

  procedure Display (Max_Candidate, Largest_Gap_So_Far, P1, P2 : Positive) is
  begin
    Put ("The largest difference between adjacent primes < ");
    Put (Max_Candidate, 0);
    Put (" is ");
    Put (Largest_Gap_So_Far, 0);
    Put (" between ");
    Put (P1, 0);
    Put (" and ");
    Put (P2, 0);
    New_Line;
  end Display;

  Max_Candidate : constant Positive := 1_000_000;
  P1 : Positive := 3;
  P2 : Positive := 5;
  Largest_Gap_So_Far : Positive := P2 - P1;
  I : Positive := 5;
  J : Positive;
  Current_Gap : Positive;

begin
  while (I < Max_Candidate) loop
    J := Next_Prime (I);
    Current_Gap := J - I;
    if (Current_Gap > Largest_Gap_So_Far) then
      P1 := I;
      P2 := J;
      Largest_Gap_So_Far := Current_Gap;
    end if;
    I := J;
  end loop;
  Display (Max_Candidate, Largest_Gap_So_Far, P1, P2);
end Largest_Difference_Between_Adjacent_Primes;

