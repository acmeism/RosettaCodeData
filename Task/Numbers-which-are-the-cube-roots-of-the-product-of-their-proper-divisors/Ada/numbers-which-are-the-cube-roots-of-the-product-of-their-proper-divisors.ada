-- Rosetta Code Task written in Ada
-- Task name: "Numbers which are the cube roots of the product of their proper divisors"
-- Task URL: https://rosettacode.org/wiki/Numbers_which_are_the_cube_roots_of_the_product_of_their_proper_divisors
-- translation from Go (loosely)
-- like the C# example, the stretch limit was increased to 5_000_000.
-- like the Delphi and Pascal examples, benchmark timing is implemented.
-- August 2024, R. B. E.

with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Numerics.Elementary_Functions; use Ada.Numerics.Elementary_Functions;
with Ada.Real_Time; use Ada.Real_Time;

procedure Numbers_Cube_Root_Product_Proper_Divisors is

  function Divisor_Count (N : Integer) return Natural is
    Count : Natural := 0;
    I, K : Natural := 1;
    J : Natural;
    Sqrt_N : constant Natural := Integer (Float'Truncation (sqrt (Float (N))));
  begin
    if ((N mod 2) = 1) then
      K := 2;
    end if;
    loop
      if ((N mod I) = 0) then
        Count := Count + 1;
        J := N / I;
        if (J /= I) then
          Count := Count + 1;
        end if;
      end if;
      I := I + K;
      exit when I > Sqrt_N;
    end loop;
    return Count;
  end Divisor_Count;

  I : Natural := 0;
  Count : Natural := 0;
  DC : Natural;
  Limit : constant Positive := 5_000_000;

  Start_Time, Stop_Time : Time;
  Elapsed_Time          : Time_Span;


begin
  Start_Time := Clock;
  New_Line;
  Put_Line ("The first 50 numbers which are the cube roots of the products of their proper divisors:");
  loop
    I := I + 1;
    DC := Divisor_Count (I);
    if ((I = 1) or (DC = 8)) then
      Count := Count + 1;
      case Count is
        when 1..50 => Put (I, 4); if ((Count mod 10) = 0) then New_Line; end if;
        when 500 => New_Line; Put ("500th: "); Put (I, 0);
        when 5_000 => New_Line (2); Put ("5_000th: "); Put (I, 0);
        when 50_000 => New_Line (2); Put ("50_000th: "); Put (I, 0);
        when 500_000 => New_Line (2); Put ("500_000th: "); Put (I, 0);
        when 5_000_000 => New_Line (2); Put ("5_000_000th: "); Put (I, 0);
        when others => null;
      end case;
    end if;
    exit when Count >= Limit;
  end loop;
  New_Line (2);
  Stop_Time := Clock;
  Elapsed_Time := Stop_Time - Start_Time;
  Put_Line ("Elapsed time: " & Duration'Image (To_Duration (Elapsed_Time)) & " seconds");
end Numbers_Cube_Root_Product_Proper_Divisors;
