pragma Ada_2022;

with Ada.Text_IO;
with Ada.Numerics; use Ada.Numerics;
with Ada.Numerics.Long_Elementary_Functions;
use  Ada.Numerics.Long_Elementary_Functions;
with Ada.Strings; use Ada.Strings;
with Ada.Strings.Fixed; use Ada.Strings.Fixed;
with Prime_Numbers;

procedure Achilles_Numbers is

   package Long_Integer_Prime_Numbers is new Prime_Numbers
     (Integer, 0, 1, 2);
   use Long_Integer_Prime_Numbers;

   --  A powerful number N is such that for every primer factor P of it
   --  P^2 also divides N
   --  Is_Powerful function decomposes the given number N in its prime factors
   --  and then it checks if each factor squared is a divisor of N
   function Is_Powerful (Number : Natural) return Boolean is
      List : constant Number_List  := Decompose (Integer (Number));
   begin
      for Index in List'Range loop
         declare
            N : constant Long_Long_Integer := Long_Long_Integer (Number);
            F : constant Long_Long_Integer := Long_Long_Integer (List (Index));
         begin
            if N mod (F * F) /= 0 then
               return False;
            end if;
         end;
      end loop;

      return True;
   end Is_Powerful;

   --  The Is_Power  function checks if a given number N can be written
   --  as a power of two integers that are > 1
   --  It makes use of the mathematical expression N = A^B
   --  taking Log(N) = Log (A^B) equals to B = Log (N) / Log (A)
   --  where the solutions are when B is an integer > 1
   function Is_Power (N : Integer) return Boolean is

      function Is_Almost_Equal (A : Long_Float;
                                B : Long_Float) return Boolean is
         Epsilon : constant := 0.000_000_000_000_001;
      begin
         if abs (A - B) < Epsilon then
            return True;
         else
            return False;
         end if;
      end Is_Almost_Equal;

      A       : Integer := 2;
      B       : Long_Float;
      Log_Of_N : constant Long_Float := Log (Long_Float (N), 2.0);
   begin
      if N = 1 then
         return True;
      end if;

      while True loop
         B := Log_Of_N / Log (Long_Float (A), 2.0);

         if Is_Almost_Equal (B, Long_Float (Integer (B)))
           and then Integer (B) > 1
         then
            return True;
         end if;

         exit when A * A > N;
         A := @ + 1;
      end loop;

      return False;

   end Is_Power;

   --  An Achilles number is a powerful number that can't be expressed
   --  as a power
   function Is_Achilles (N : Integer) return Boolean is
   begin
      if Is_Powerful (N) then
         if Is_Power (N) = False then
            return True;
         end if;
      end if;

      return False;
   end Is_Achilles;

   --  Calculates the Euler totient of a number
   function Totient (N : Integer) return Integer is
      Tot : Integer := N;
      I   : Integer;
      N2  : Integer := N;
   begin
      I := 2;
      while I * I <= N2 loop
         if N2 mod I = 0 then
            while N2 mod I = 0 loop
               N2 := N2 / I;
            end loop;
            Tot := Tot - Tot / I;
         end if;

         if I = 2 then
            I := 1;
         end if;
         I := I + 2;
      end loop;

      if N2 > 1 then
         Tot := Tot - Tot / N2;
      end if;

      return Tot;
   end Totient;

   --  A Strong Achilles number is an Achilles number whose Euler Totient
   --  is also an Achilles number
   function Is_Strong_Achilles (N : Integer) return Boolean is
   begin
      if Is_Achilles (N) then
         if Is_Achilles (Totient (N)) then
            return True;
         end if;
      end if;

      return False;
   end Is_Strong_Achilles;

   --  Counts the digits in a number by taking the string from
   --  its 'Image attribute, trimming it and counting the characters
   function Count_Digits (N : Integer) return Natural is
      Integer_Str : constant String := Trim (N'Image, Both);
   begin
      return Integer_Str'Length;
   end Count_Digits;

begin
   --  Find the first 50 Achilles numbers
   declare
      N : Integer := 1;
      Count : Integer := 1;
   begin
      Ada.Text_IO.Put_Line ("First 50 Achilles numbers:");

      while Count <= 50 loop

         if Is_Achilles (N) then
            Count := @ + 1;
            Ada.Text_IO.Put (N'Image & " ");
         end if;

         N := @ + 1;
      end loop;

      Ada.Text_IO.New_Line;
   end;

   --  Find the first 20 Strong Achilles numbers
   declare
      N : Integer := 1;
      Count : Integer := 1;
   begin
      Ada.Text_IO.Put_Line ("First 20 Strong Achilles numbers:");

      while Count <= 20 loop

         if Is_Strong_Achilles (N) then
            Count := @ + 1;
            Ada.Text_IO.Put (N'Image & " ");
         end if;

         N := @ + 1;
      end loop;

      Ada.Text_IO.New_Line;
   end;

   --  Count numbers with digits
   declare
      Counts : array (2 .. 6) of Natural := [others => 0];
      N      : Integer := 1;
   begin
      Ada.Text_IO.Put_Line ("Number of Achilles numbers with:");

      while Count_Digits (N) <= Counts'Last loop

         --  Ada.Text_IO.Put_Line ("Testing: " & N'Image);

         if Is_Achilles (N) then
            Counts (Count_Digits (N)) := @ + 1;
         end if;
         N := @ + 1;
      end loop;

      for I in Counts'Range loop
         Ada.Text_IO.Put_Line (I'Image & " digits: " & Counts (I)'Image);
      end loop;
   end;
end Achilles_Numbers;
