-- Rosetta Code Task written in Ada
-- Twin primes
-- https://rosettacode.org/wiki/Twin_primes
-- Using GNAT Big Integers, GNAT version 14.1, MacOS 14.6.1, M1 chip
-- Brute-force method; I tried several other methods...results about the same: very slow after 10^7
-- I terminated the execution after 10^7, I lost patience for 10^8 and 10^9
-- September 2024, R. B. E. (removed manually inserted line numbers)

pragma Ada_2022;
with Ada.Text_IO; use Ada.Text_IO;
with Ada.Integer_Text_IO; use Ada.Integer_Text_IO;
with Ada.Numerics.Big_Numbers.Big_Integers; use Ada.Numerics.Big_Numbers.Big_Integers;
with Ada.Real_Time; use Ada.Real_Time;

procedure Twin_Primes is

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

  procedure Display_Results (Limit : Big_Positive; Total : Natural; Elapsed_Time : Time_Span) is
  begin
    Put ("There are ");
    Put (Total, 10);
    Put (" Twin Primes under ");
    Put (To_String (Limit));
    Put (" CPU Time spent so far ");
    Put (Duration'Image (To_Duration (Elapsed_Time)) & " seconds");
    New_Line;
  end Display_Results;

  Limit_1 : Big_Positive := To_Big_Integer (10);
  Limit_2 : Big_Positive := Limit_1 ** 2;
  Limit_3 : Big_Positive := Limit_1 ** 3;
  Limit_4 : Big_Positive := Limit_1 ** 4;
  Limit_5 : Big_Positive := Limit_1 ** 5;
  Limit_6 : Big_Positive := Limit_1 ** 6;
  Limit_7 : Big_Positive := Limit_1 ** 7;
  Limit_8 : Big_Positive := Limit_1 ** 8;
  Limit_9 : Big_Positive := Limit_1 ** 9;
  Max : Big_Positive := Limit_1 ** 10;

  Big_One :  Big_Positive := To_Big_Integer (1);
  Big_Two :  Big_Positive := To_Big_Integer (2);
  Big_Three :  Big_Positive := To_Big_Integer (3);
  Candidate : Big_Positive := Big_Three;
  Twin_Prime_Count : Natural := 0;
  Run_Display : Natural := 0;
  Start_Time, Stop_Time : Time;
  Elapsed_Time          : Time_Span;

begin
  Start_Time := Clock;
  loop
    if (Is_Prime (Candidate) and (Is_Prime (Candidate + Big_Two))) then
      Twin_Prime_Count := Twin_Prime_Count + 1;
    end if;
    Candidate := Candidate + Big_Two;
    if (Candidate - Big_One = Limit_1) then
      Stop_Time := Clock;
      Elapsed_Time := Stop_Time - Start_Time;
      Display_Results (Limit_1, Twin_Prime_Count, Elapsed_Time);
    elsif (Candidate - Big_One = Limit_2) then
      Stop_Time := Clock;
      Elapsed_Time := Stop_Time - Start_Time;
      Display_Results (Limit_2, Twin_Prime_Count, Elapsed_Time);
    elsif (Candidate - Big_One = Limit_3) then
      Stop_Time := Clock;
      Elapsed_Time := Stop_Time - Start_Time;
      Display_Results (Limit_3, Twin_Prime_Count, Elapsed_Time);
    elsif (Candidate - Big_One = Limit_4) then
      Stop_Time := Clock;
      Elapsed_Time := Stop_Time - Start_Time;
      Display_Results (Limit_4, Twin_Prime_Count, Elapsed_Time);
    elsif (Candidate - Big_One = Limit_5) then
      Stop_Time := Clock;
      Elapsed_Time := Stop_Time - Start_Time;
      Display_Results (Limit_5, Twin_Prime_Count, Elapsed_Time);
    elsif (Candidate - Big_One = Limit_6) then
      Stop_Time := Clock;
      Elapsed_Time := Stop_Time - Start_Time;
      Display_Results (Limit_6, Twin_Prime_Count, Elapsed_Time);
    elsif (Candidate - Big_One = Limit_7) then
      Stop_Time := Clock;
      Elapsed_Time := Stop_Time - Start_Time;
      Display_Results (Limit_7, Twin_Prime_Count, Elapsed_Time);
    elsif (Candidate - Big_One = Limit_8) then
      Stop_Time := Clock;
      Elapsed_Time := Stop_Time - Start_Time;
      Display_Results (Limit_8, Twin_Prime_Count, Elapsed_Time);
    elsif (Candidate - Big_One = Limit_9) then
      Stop_Time := Clock;
      Elapsed_Time := Stop_Time - Start_Time;
      Display_Results (Limit_9, Twin_Prime_Count, Elapsed_Time);
    elsif (Candidate - Big_One = Max) then
      Stop_Time := Clock;
      Elapsed_Time := Stop_Time - Start_Time;
      Display_Results (Max, Twin_Prime_Count, Elapsed_Time);
    else
      null;
    end if;
--    exit when (Candidate > Max);
    exit when (Candidate > Limit_7);
  end loop;
end Twin_Primes;
