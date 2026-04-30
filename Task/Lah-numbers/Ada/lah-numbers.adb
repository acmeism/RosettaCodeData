-- Rosetta Code Task written in Ada
-- Lah numbers
-- https://rosettacode.org/wiki/Lah_numbers
-- (Mostly) translated from the AWK example
-- Proper formatting of the Big Integers would be nice.
-- Not important here, but in general, the factorials should be cached for greater performance.
-- Could use alternate libraries for large integers...
-- January 2025, R. B. E.
-- Using GNAT Big Integers, GNAT version 14.2, MacOS 15.3, M1 chip

pragma Ada_2022;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Numerics.Big_Numbers.Big_Integers; use Ada.Numerics.Big_Numbers.Big_Integers;

procedure Lah_Numbers is

  function Factorial (F : Natural) return Big_Positive is
    Prod : Big_Positive := To_Big_Integer (1);
  begin
    for I in reverse 2..F loop
      Prod := Prod * To_Big_Integer (I);
    end loop;
    return Prod;
  end Factorial;

  function Lah (N, K : Natural) return Big_Natural is
  begin
    if (K = 1) then
      return Factorial (N);
    end if;
    if (K = N) then
      return (To_Big_Integer (1));
    end if;
    if (K > N) then
      return (To_Big_Integer (0));
    end if;
    if ((K < 1) or (N < 1)) then
      return (To_Big_Integer (0));
    end if;
    return (Factorial (N) * Factorial (N-1)) / (Factorial (K) * Factorial (K-1)) / Factorial (N-K);
  end Lah;

  Biggest_Lah_Number_in_Row_100 : Big_Natural := To_Big_Integer (0);
  Candidate_Biggest_Lah_Number_in_Row_100 : Big_Positive;

begin
  Put_Line ("unsigned Lah numbers: L(n,k)");
  Put ("n/k");
  for I in 0..12 loop
    Put (I, 3);
  end loop;
  New_Line;
  for Row in 0..12 loop
    Put (Row, 2);
    for Col in 0..Row loop
      Put (To_String (Lah (Row, Col)));
    end loop;
    New_Line;
  end loop;
  New_Line;
  for Col in 0..12 loop
    Candidate_Biggest_Lah_Number_in_Row_100 := Lah (100, Col);
    if Biggest_Lah_Number_in_Row_100 < Candidate_Biggest_Lah_Number_in_Row_100 then
      Biggest_Lah_Number_in_Row_100 := Candidate_Biggest_Lah_Number_in_Row_100;
    end if;
  end loop;
  Put_Line ("Maximum value of L(n,k) where n = 100:");
  Put_Line (To_String (Biggest_Lah_Number_in_Row_100));
end Lah_Numbers;
