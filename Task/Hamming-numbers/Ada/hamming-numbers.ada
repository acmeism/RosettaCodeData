with Ada.Numerics.Generic_Elementary_Functions;
with Ada.Text_IO; use Ada.Text_IO;
with GNATCOLL.GMP.Integers;
with GNATCOLL.GMP.Lib;

procedure Hamming is

   type Log_Type is new Long_Long_Float;
   package Funcs is new Ada.Numerics.Generic_Elementary_Functions (Log_Type);

   type Factors_Array is array (Positive range <>) of Positive;

   generic
      Factors : Factors_Array := (2, 3, 5);
      --  The factors for smooth numbers. Hamming numbers are 5-smooth.
   package Smooth_Numbers is
      type Number is private;
      function Compute (Nth : Positive) return Number;
      function Image (N : Number) return String;

   private
      type Exponent_Type is new Natural;
      type Exponents_Array is array (Factors'Range) of Exponent_Type;
      --  Numbers are stored as the exponents of the prime factors.

      type Number is record
         Exponents : Exponents_Array;
         Log       : Log_Type;
         --  The log of the value, used to ease sorting.
      end record;

      function "=" (N1, N2 : Number) return Boolean
        is (for all F in Factors'Range => N1.Exponents (F) = N2.Exponents (F));
   end Smooth_Numbers;

   package body Smooth_Numbers is
      One : constant Number := (Exponents => (others => 0), Log => 0.0);
      Factors_Log : array (Factors'Range) of Log_Type;

      function Image (N : Number) return String is
         use GNATCOLL.GMP.Integers, GNATCOLL.GMP.Lib;
         R, Tmp : Big_Integer;
      begin
         Set (R, "1");
         for F in Factors'Range loop
            Set (Tmp, Factors (F)'Image);
            Raise_To_N (Tmp, GNATCOLL.GMP.Unsigned_Long (N.Exponents (F)));
            Multiply (R, Tmp);
         end loop;
         return Image (R);
      end Image;

      function Compute (Nth : Positive) return Number is
         Candidates : array (Factors'Range) of Number;

         Values     : array (1 .. Nth) of Number;
         --  Will result in Storage_Error for very large values of Nth

         Indices    : array (Factors'Range) of Natural :=
            (others => Values'First);
         Current    : Number;
         Tmp        : Number;
      begin
         for F in Factors'Range loop
            Factors_Log (F) := Funcs.Log (Log_Type (Factors (F)));
            Candidates (F) := One;
            Candidates (F).Exponents (F) := 1;
            Candidates (F).Log := Factors_Log (F);
         end loop;

         Values (1) := One;

         for Count in 2 .. Nth loop
            --  Find next value (the lowest of the candidates)
            Current := Candidates (Factors'First);
            for F in Factors'First + 1 .. Factors'Last loop
               if Candidates (F).Log < Current.Log then
                  Current := Candidates (F);
               end if;
            end loop;

            Values (Count) := Current;

            --  Update the candidates. There might be several candidates with
            --  the same value
            for F in Factors'Range loop
               if Candidates (F) = Current then
                  Indices (F) := Indices (F) + 1;

                  Tmp := Values (Indices (F));
                  Tmp.Exponents (F) := Tmp.Exponents (F) + 1;
                  Tmp.Log := Tmp.Log + Factors_Log (F);

                  Candidates (F) := Tmp;
               end if;
            end loop;
         end loop;

         return Values (Nth);
      end Compute;
   end Smooth_Numbers;

   package Hamming is new Smooth_Numbers ((2, 3, 5));

begin
   for N in 1 .. 20 loop
      Put (" " & Hamming.Image (Hamming.Compute (N)));
   end loop;
   New_Line;

   Put_Line (Hamming.Image (Hamming.Compute (1691)));
   Put_Line (Hamming.Image (Hamming.Compute (1_000_000)));
end Hamming;
