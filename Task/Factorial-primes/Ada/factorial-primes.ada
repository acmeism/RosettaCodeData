-- Rosetta Code Task written in Ada
-- Factorial primes
-- https://rosettacode.org/wiki/Factorial_primes
-- August 2024, R. B. E.
-- Using GNAT Big Integers, GNAT version 14.1, MacOS 14.6.1, M1 chip

pragma Ada_2022;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Numerics.Big_Numbers.Big_Integers; use Ada.Numerics.Big_Numbers.Big_Integers;

procedure Factorial_Primes is

  function Is_Prime (N : in Big_Integer) return Boolean is
    Big_0 : Big_Natural := To_Big_Integer (0);
    Big_2 : Big_Natural := To_Big_Integer (2);
    Big_3 : Big_Natural := To_Big_Integer (3);
    Big_Temp : Big_Natural := To_Big_Integer (5);
  begin
    if N < Big_2 then
      return False;
    end if;
    if N mod Big_2 = Big_0 then
      return N = Big_2;
    end if;
    if N mod Big_3 = Big_0 then
      return N = Big_3;
    end if;
    while Big_Temp * Big_Temp <= N loop
      if N mod Big_Temp = Big_0 then
        return False;
      end if;
      Big_Temp := Big_Temp + Big_2;
      if N mod Big_Temp = Big_0 then
        return False;
      end if;
      Big_Temp := Big_Temp + 4;
    end loop;
    return True;
  end Is_Prime;

  function Factorial (N : Positive) return Big_Integer is
    type Factorial_Array is array (1..12) of Big_Integer;
    First12_Facts : Factorial_Array;
    Result : Big_Integer;
  begin
    First12_Facts (1) := To_Big_Integer (1);
    for I in 2..12 loop
      First12_Facts (I) := First12_Facts (I-1) * To_Big_Integer (I);
    end loop;
    if (N <= 12) then
      return First12_Facts (N);
    else
      Result := First12_Facts (12);
      for I in 13..N loop
        Result := Result * To_Big_Integer (I);
      end loop;
    end if;
    return Result;
  end Factorial;

  Fact : Big_Integer;
  Fact_Plus_One : Big_Integer;
  Fact_Minus_One : Big_Integer;
  Big_One : constant Big_Integer := To_Big_Integer (1);
  I, Count : Natural := 0;
  Limit : constant Positive := 10;

begin
  loop
    I := I + 1;
    Fact := Factorial (I);
    if (is_Prime (Fact - Big_One)) then
      Count := Count + 1;
      Put (Count, 3);
      Put (": ");
      Put (I, 5);
      Put ("! - 1 ");
      Fact_Minus_One := Fact - Big_One;
      Put (To_String (Arg => Fact_Minus_One, Width => 40));
      New_Line;
    end if;
    if (is_Prime (Fact + Big_One)) then
      Count := Count + 1;
      Put (Count, 3);
      Put (": ");
      Put (I, 5);
      Put ("! + 1 ");
      Fact_Plus_One := Fact + Big_One;
      Put (To_String (Arg => Fact_Plus_One, Width => 40));
      New_Line;
    end if;
    exit when Count >= Limit;
  end loop;
end Factorial_Primes;
