pragma Ada_2022;

with Ada.Text_IO;

with Ada.Containers.Indefinite_Vectors;
with Ada.Containers.Indefinite_Ordered_Sets;

procedure Upside_Down_Numbers is

   --  a rather slow algorithm that proceeds by recursive expansion; i.e.,
   --  a straightforward implementation via the definition

   package IO renames Ada.Text_IO;

   subtype Digit is Integer range 1 .. 9;

   Mirror : constant array (Digit) of Digit :=
      [for Ith in Digit => 10 - Ith];

   type Upside_Down_Number is array (Positive range <>) of Digit;

   procedure Put (Number : Upside_Down_Number) is
      package Digit_IO is new IO.Integer_IO (Num => Digit);
   begin
      for N of Number loop
         Digit_IO.Put (N, 0);
      end loop;
   end Put;

   package Upside_Down_Vecs is new Ada.Containers.Indefinite_Vectors
     (Index_Type => Positive, Element_Type => Upside_Down_Number);
   subtype Upside_Down_Vec is Upside_Down_Vecs.Vector;

   package Upside_Down_Sets is new Ada.Containers.Indefinite_Ordered_Sets
     (Element_Type => Upside_Down_Number);
   subtype Upside_Down_Set is Upside_Down_Sets.Set;

   function Expand_Even (Numbers : Upside_Down_Set) return Upside_Down_Set is
      --  if Numbers holds even-length upside-down numbers,
      --  this expands them to corresponding odd-length upside-down numbers

      Result : Upside_Down_Set;

      Length      : constant Positive := Numbers.First_Element'Length;
      Half_Length : constant Positive := Length / 2;

      New_Number : Upside_Down_Number (1 .. Length + 1);

   begin

      for Old_Number of Numbers loop

         for Ith in 1 .. Half_Length loop
            New_Number (Ith)                  := Old_Number (Ith);
            New_Number (Length + 1 - Ith + 1) := Old_Number (Length - Ith + 1);
         end loop;

         New_Number (Half_Length + 1) := 5;
         if not Result.Contains (New_Number) then
            Result.Insert (New_Number);
         end if;

      end loop;

      return Result;

   end Expand_Even;

   function Expand_Odd (Numbers : Upside_Down_Set) return Upside_Down_Set is
      --  if Numbers holds odd-length upside-down numbers,
      --  this expands them to corresponding even-length upside-down numbers
      --
      --  alas, this is inefficient not only by exhaustive enumeration,
      --  but by generating several numbers more than once

      Result : Upside_Down_Set;

      Length      : constant Positive := Numbers.First_Element'Length;
      Half_Length : constant Positive := (Length + 1) / 2;

      New_Number : Upside_Down_Number (1 .. Length + 1);

   begin

      for Old_Number of Numbers loop
         for Breakpoint in 1 .. Half_Length loop

            for Ith in 1 .. Half_Length loop

               if Ith < Breakpoint then
                  New_Number (Ith)                  := Old_Number (Ith);
                  New_Number (Length + 1 - Ith + 1) :=
                    Old_Number (Length - Ith + 1);

               elsif Ith >= Breakpoint then
                  New_Number (Ith + 1)          := Old_Number (Ith);
                  New_Number (Length + 1 - Ith) :=
                    Old_Number (Length - Ith + 1);
               end if;

            end loop;

            for D in Digit loop
               New_Number (Breakpoint)                  := D;
               New_Number (Length + 1 - Breakpoint + 1) := Mirror (D);
               if not Result.Contains (New_Number) then
                  Result.Insert (New_Number);
               end if;
            end loop;

         end loop;
      end loop;

      return Result;

   end Expand_Odd;

   function Expand (Number : Upside_Down_Set) return Upside_Down_Set is
     (if Number.First_Element'Length mod 2 = 0 then Expand_Even (Number)
      else Expand_Odd (Number));

   Iterations      : array (1 .. 100) of Upside_Down_Set;
   Result          : Upside_Down_Vec;
   Number_Computed : Positive := 1;
   Ith             : Positive := 1;

begin
   IO.Put_Line ("Slow Formula");
   IO.Put_Line ("==== =======");
   Iterations (1).Insert (Upside_Down_Number'[5]);
   Result.Append (Upside_Down_Number'[5]);
   while Number_Computed < 5_000_000 loop
      Iterations (Ith + 1) := Expand (Iterations (Ith));
      Number_Computed      := @ + Positive (Iterations (Ith + 1).Length);
      for Each of Iterations (Ith + 1) loop
         Result.Append (Each);
      end loop;
      Ith := @ + 1;
   end loop;
   IO.Put_Line ("Computed" & Number_Computed'Image & " upside-down numbers");
   IO.Put ("The first 50: ");
   for Ith in 1 .. 50 loop
      Put (Result (Ith));
      IO.Put (", ");
   end loop;
   IO.New_Line;
   IO.Put ("The 500th: ");
   Put (Result (500));
   IO.New_Line;
   IO.Put ("The 5_000th: ");
   Put (Result (5_000));
   IO.New_Line;
   IO.Put ("The 500_000th: ");
   Put (Result (500_000));
   IO.New_Line;
   IO.Put ("The 5_000_000th: ");
   Put (Result (5_000_000));
   IO.New_Line;
end Upside_Down_Numbers;
