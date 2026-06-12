-- Wolstenholme numbers
-- J. Carter     2023 May

with Ada.Numerics.Generic_Elementary_Functions;
with Ada.Text_IO;
with System;

procedure Wolstenholme is
   type Number is mod System.Max_Binary_Modulus;
   type Real is digits System.Max_Digits;

   package Math is new Ada.Numerics.Generic_Elementary_Functions (Float_Type => Real);

   function GCD (Left : in Number; Right : in Number) return Number;
   -- Greatest Common Divisor

   function Prime (Value : in Number) return Boolean;
   -- Returns True if Value is prime; False otherwise

   function GCD (Left : in Number; Right : in Number) return Number is
      Min       : Number := Number'Min (Left, Right);
      Max       : Number := Number'Max (Left, Right);
      Remainder : Number;
   begin -- GCD
      Reduce : loop
         if Min = 0 then
            return Max;
         end if;

         Remainder := Max rem Min;
         Max := Min;
         Min := Remainder;
      end loop Reduce;
   end GCD;

   function Prime (Value : in Number) return Boolean is
      Last : constant Number := Number (Real'Truncation (Math.Sqrt (Real (Value) ) ) );

      Div : Number := 3;
   begin -- Prime
      All_Divisors : loop
         exit All_Divisors when Div > Last;

         if Value rem Div = 0 then
            return False;
         end if;

         Div := Div + 2;
      end loop All_Divisors;

      return True;
   end Prime;

   Num : Number := 1;
   Den : Number := 1;
   Wrk : Number;
begin -- Wolstenholme
   Ada.Text_IO.Put_Line (Item => (1 .. 17 => ' ') & '1');

   All_Numbers : for K in Number range 2 .. 20 loop
      Wrk := K ** 2;
      Num := Num * Wrk + Den;
      Den := Den * Wrk;
      Wrk := GCD (Num, Den);
      Num := Num / Wrk;
      Den := Den / Wrk;

      Put : declare
         Image : constant String := Num'Image;
      begin -- Put
         Ada.Text_IO.Put (Item => (1 .. 18 - Image'Length => ' ') & Image);
      end Put;

      if Prime (Num) then
         Ada.Text_IO.Put (Item => '*');
      end if;

      Ada.Text_IO.New_Line;
   end loop All_Numbers;

   Ada.Text_IO.Put_Line (Item => "* Number is prime");
end Wolstenholme;
