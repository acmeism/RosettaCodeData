-- Rosetta Code Task written in Ada
-- Extreme primes
-- https://rosettacode.org/wiki/Extreme_primes
-- Inspired by virtually all of the other solutions, not any particular one
-- Output similar to the Perl solution
-- Uses GNAT Big_Integers
-- Shows elapsed time
-- Tested with GNAT 14.1.0, MacOS 14.6.1, M1 chip
-- September 2024, R. B. E.

pragma Ada_2022;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Numerics.Big_Numbers.Big_Integers; use Ada.Numerics.Big_Numbers.Big_Integers;
with Ada.Real_Time; use Ada.Real_Time;

procedure Extreme_Primes is

  function Is_Prime (N : Big_Positive) return Boolean is
    Big0 : constant Big_Natural := To_Big_Integer (0);
    Big2 : constant Big_Positive := To_Big_Integer (2);
    Big3 : constant Big_Positive := To_Big_Integer (3);
    Big4 : constant Big_Positive := To_Big_Integer (4);
    D : Big_Positive := To_Big_Integer (5);
  begin
    if N < Big2 then
      return False;
    end if;
    if (N = Big2) or (N = Big3) then
      return True;
    end if;
    if N mod Big2 = Big0 then
      return False;
    end if;
    if N mod Big3 = Big0 then
      return False;
    end if;
    while D * D <= N loop
      if N mod D = Big0 then
        return False;
      end if;
      D := D + Big2;
      if N mod D = Big0 then
        return False;
      end if;
      D := D + Big4;
    end loop;
    return True;
  end Is_Prime;

  function Determine_the_Next_Prime (N : Big_Positive) return Big_Positive is
    Big1 : constant Big_Natural := To_Big_Integer (1);
    M : Big_Positive := N + 1;
  begin
    while not Is_Prime (M) loop
      M := M + Big1;
    end loop;
    return M;
  end Determine_the_Next_Prime;

  procedure Display (S : Positive; Last_Prime_Used, EP : Big_Positive) is
  begin
    Put (S, 7);
    Put (To_String (Arg => Last_Prime_Used, Width => 14));
    Put (To_String (Arg => EP, Width => 16));
    New_Line;
  end Display;

  Big0 : constant Big_Positive := To_Big_Integer (0);
  Big2 : constant Big_Positive := To_Big_Integer (2);

  Sequence_Number : Natural := 1;
  Previous_Prime_Number : Big_Positive := Big2;
  Sum : Big_Positive := Big2;

  Start_Time, Stop_Time : Time;
  Elapsed_Time          : Time_Span;

begin
  Start_Time := Clock;
  Sum := Big0;
  Previous_Prime_Number := Big2;
  Sum := Sum + Previous_Prime_Number;
  New_Line;
  Put_Line ("Sum of the prime series...");
  Put_Line ("Sequence #    Largest Prime     Sum");
  Display (Sequence_Number, Previous_Prime_Number, Sum);
  loop
    Previous_Prime_Number := Determine_the_Next_Prime (Previous_Prime_Number);
    Sum := Sum + Previous_Prime_Number;
    if Is_Prime (Sum) then
      Sequence_Number := Sequence_Number + 1;
      case Sequence_Number is
        when 2..30 => Display (Sequence_Number, Previous_Prime_Number, Sum);
        when 1_000 | 2_000 | 3_000 | 4_000 | 5_000 => Display (Sequence_Number, Previous_Prime_Number, Sum);
        when 7_500 | 10_000 => Display (Sequence_Number, Previous_Prime_Number, Sum);
        when others => null;
      end case;
    end if;
    exit when Sequence_Number = 10_000;
  end loop;
  New_Line;
  Stop_Time := Clock;
  Elapsed_Time := Stop_Time - Start_Time;
  Put_Line ("Elapsed time: " & Duration'Image (To_Duration (Elapsed_Time)) & " seconds");
  New_Line;
end Extreme_Primes;
