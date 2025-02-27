-- Rosetta Code Task written in Ada
-- Left factorials
-- https://rosettacode.org/wiki/Left_factorials
-- (Mostly) translated from the AWK example
-- February 2025, R. B. E.
-- Using PragmARC.Unbounded_Numbers, GNAT version 14.2.0-3, MacOS 15.3, M1 chip

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with PragmARC.Unbounded_Numbers.Integers; use PragmARC.Unbounded_Numbers.Integers;

procedure Left_Factorials is

  function Left_Fact (F : Natural) return Unbounded_Integer is
    Result : Unbounded_Integer := To_Unbounded_Integer (0);
    Adder : Unbounded_Integer := To_Unbounded_Integer (1);
  begin
    if F = 0 then
      return Result;
    end if;
    for K in 1..F loop
      Result := Result + Adder;
      Adder := Adder * To_Unbounded_Integer (K);
    end loop;
    return Result;
  end Left_Fact;

  function Brute_Force_Digit_String_Length (N : in Unbounded_Integer) return Natural is
    Big_Zero : constant Unbounded_Integer := To_Unbounded_Integer (0);
    Big_Ten : constant Unbounded_Integer := To_Unbounded_Integer (10);
    Local_N : Unbounded_Integer := N;
    String_Length : Natural := 0;
  begin
    loop
      exit when Local_N = Big_Zero;
      Local_N := Local_N / Big_Ten;
      String_Length := String_Length + 1;
    end loop;
    return String_Length;
  end Brute_Force_Digit_String_Length;

begin
  for I in 0..10 loop
    Put ("!");
    Put (I, 0);
    Put (" = ");
    Put (Image (Value => Left_Fact (I)));
    New_Line;
  end loop;
  New_Line;
  for I in 20..110 loop
    if (I mod 10) = 0 then
      Put ("!");
      Put (I, 0);
      Put (" =");
      if I < 70 then
        Put (" ");
      else
        New_Line;
      end if;
      Put (Image (Value => Left_Fact (I)));
      New_Line;
    end if;
  end loop;
  New_Line;
  for I in 1_000..10_000 loop
    if (I mod 1_000) = 0 then
      Put ("!");
      Put (I, 0);
      Put (" has ");
      Put (Brute_Force_Digit_String_Length (Left_Fact (I)), 0);
      Put_Line (" digits.");
    end if;
  end loop;
  New_Line;
end Left_Factorials;
