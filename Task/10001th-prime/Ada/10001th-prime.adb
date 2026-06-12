-- Rosetta Code Task written in Ada
-- 10001th prime
-- https://rosettacode.org/wiki/10001th_prime
-- November 2024, R. B. E.

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;

procedure Ten_Thousand_One_Prime is

  function Is_Prime (N : in Natural) return Boolean is
    Temp : Natural := 5;
  begin
    if N < 2 then
      return False;
    end if;
    if N mod 2 = 0 then
      return N = 2;
    end if;
    if N mod 3 = 00 then
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

  Nth_Prime : constant Positive := 10_001;
  Prime_Counter : Natural := 0;
  Prime_Candidate : Positive := 2;

begin
  loop
    if Is_Prime (Prime_Candidate) then
      Prime_Counter := Prime_Counter + 1;
    end if;
    exit when Prime_Counter = Nth_Prime;
    if Prime_Candidate = 2 then
      Prime_Candidate := Prime_Candidate + 1;
    else
      Prime_Candidate := Prime_Candidate + 2;
    end if;
  end loop;
  Put ("The ");
  Put (Nth_Prime, 0);
  Put ("th Prime is ");
  Put (Prime_Candidate, 0);
  New_Line;
end Ten_Thousand_One_Prime;
