-- Magic constants
-- J. Carter     2024 May

with Ada.Text_IO;
with System;

procedure Magic_Constant is
   type Big_U is mod System.Max_Binary_Modulus;

   function Magic (Order : in Big_U) return Big_U with
      Pre => Order > 2;
   -- Returns the constant for the magic square of order Order

   function Order (Guess : in Big_U) return Big_U;
   -- Returns the order of the smallest magic square with constant > Guess

   function Image (N : in Big_U; Width : in Positive) return String;
   -- Returns a blank-filled image of N of at least width characters

   function Magic (Order : in Big_U) return Big_U is
      (Order * (Order ** 2 + 1) / 2);

   function Order (Guess : in Big_U) return Big_U is
      Min  : Big_U :=         3;
      Max  : Big_U := 5_850_000;
      Mid  : Big_U;
      Prev : Big_U := 0;
   begin -- Order
      Search : loop
         Mid := Min + (Max - Min) / 2;

         exit Search when Mid = Prev;

         Prev := Mid;

         if Magic (Mid) > Guess and (Mid = 3 or else Magic (Mid - 1) <= Guess) then
            return Mid;
         end if;

         if Magic (Mid) > Guess then
            Max := Mid;
         else
            Min := Mid;
         end if;
      end loop Search;

      raise Program_Error with "Order: no solution for" & Guess'Image;
   end Order;

   function Image (N : in Big_U; Width : in Positive) return String is
      Raw : String renames N'Image;
      Img : String renames Raw (2 .. Raw'Last);
   begin -- Image
      return (1 .. Width - Img'Length => ' ') & Img;
   end Image;
begin -- Magic_Constant
   First_20 : for N in Big_U range 3 .. 22 loop
      Ada.Text_IO.Put_Line (Item => Image (N, 2) & Image (Magic (N), 5) );
   end loop First_20;

   Ada.Text_IO.New_Line;
   Ada.Text_IO.Put_Line (Item => "1000" & Magic (1000)'Image);
   Ada.Text_IO.New_Line;

   Ten_To : for P in 1 .. (if Big_U'Size < 64 then 9 elsif Big_U'Size < 128 then 18 else 20) loop
      Ada.Text_IO.Put_Line (Item => "10 ** " & Image (Big_U (P), 2) & Image (Order (10 ** P), 8) );
   end loop Ten_To;
end Magic_Constant;
