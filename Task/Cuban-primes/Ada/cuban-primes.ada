-- Rosetta Code Task written in Ada
-- Cuban primes (related to "Cubes", not "Cubans")
-- https://rosettacode.org/wiki/Cuban_primes
-- July 2024, R. B. E.

-- Using this Cuban Primes Definition: primes of the form: n^3 - (n-1)^3.

-- ToDo:
-- Commatize the results (an advanced subtask)
-- Could replace the "activity dots" generated during the big calculations with a spinner

-- NOTE: Using GNAT Big_Numbers package.
-- Takes a very long time to generate the 100_000th cuban prime: about 75 minutes on a M1 Mac Mini.

pragma Ada_2022;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;
with Ada.Numerics.Big_Numbers.Big_Integers; use Ada.Numerics.Big_Numbers.Big_Integers;
with Ada.Strings; use Ada.Strings;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with Ada.Strings.Maps;  use Ada.Strings.Maps;
with Ada.Real_Time; use Ada.Real_Time;

procedure Cuban_Primes is

  function Is_Prime (A : Positive) return Boolean is
    D : Positive;
  begin
    if A < 2 then
      return False;
    end if;
    if A in 2 .. 3 then
      return True;
    end if;
    if A mod 2 = 0 then
      return False;
    end if;
    if A mod 3 = 0 then
      return False;
    end if;
    D := 5;
    while D * D <= A loop
      if A mod D = 0 then
        return False;
      end if;
      D := D + 2;
      if A mod D = 0 then
        return False;
      end if;
      D := D + 4;
    end loop;
    return True;
  end Is_Prime;

  function Is_Prime (A : Big_Natural) return Boolean is
    D : Big_Natural;
    B0 : constant Big_Natural := To_Big_Integer (0);
    B1 : constant Big_Natural := To_Big_Integer (1);
    B2 : constant Big_Natural := To_Big_Integer (2);
    B3 : constant Big_Natural := To_Big_Integer (3);
    B4 : constant Big_Natural := To_Big_Integer (4);
    B5 : constant Big_Natural := To_Big_Integer (5);
  begin
    if A < B2 then
      return False;
    end if;
    if (A = B2) or (A = B3) then
      return True;
    end if;
    if A mod B2 = B0 then
      return False;
    end if;
    if A mod B3 = B0 then
      return False;
    end if;
    D := B5;
    while D * D <= A loop
      if A mod D = B0 then
        return False;
      end if;
      D := D + B2;
      if A mod D = B0 then
        return False;
      end if;
      D := D + B4;
    end loop;
    return True;
  end Is_Prime;

  Cuban_Count : Natural := 1;
  Candidate : Natural;
  Big_Candidate : Big_Natural;
  Max_Cuban_for_the_Table : constant Integer := 200;
  Max_Cuban_below_the_Table : constant Integer := 100_000;
  Start_Time, Stop_Time : Time;
  Elapsed_Time          : Time_Span;

begin
  Put ("The first ");
  Put (Max_Cuban_for_the_Table, 1);
  Put_Line (" Cuban Primes...");
  for I in 1 .. Integer'Last loop
    Candidate := ((I + 1) ** 3) - (I ** 3);
    if Is_Prime (Candidate) then
      Put (Candidate, 8);
      if ((Cuban_Count rem 14) = 0) then
        New_Line;
      end if;
      Cuban_Count := Cuban_Count + 1;
    end if;
    exit when Cuban_Count > Max_Cuban_for_the_Table;
  end loop;
  New_Line (2);
  Cuban_Count := 1;
  Start_Time := Clock;
  Put ("The ");
  Put (Max_Cuban_below_the_Table, 1);
  Put ("th Cuban Prime is: ");
  for I in 1 .. Integer'Last loop
    Big_Candidate := (((To_Big_Integer (I) + 1) ** 3) - (To_Big_Integer (I) ** 3));
    if Is_Prime (Big_Candidate) then
      Cuban_Count := Cuban_Count + 1;
      if (Cuban_Count rem 10_000) = 0 then
        Put (".");
      end if;
    end if;
    exit when Cuban_Count = Max_Cuban_below_the_Table;
  end loop;
  New_Line;
  Put (Trim (To_String (Big_Candidate), Right));
  Stop_Time    := Clock;
  Elapsed_Time := Stop_Time - Start_Time;
  New_Line;
  Put_Line ("Elapsed time to calculate: " & Duration'Image (To_Duration (Elapsed_Time)) & " seconds");
end Cuban_Primes;
