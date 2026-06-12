-- Find the maximum absolute difference between adjacent values in a list,  and output all pairs with that difference
-- J. Carter     2023 Apr
-- Uses the PragmAda Reusable Components (https://github.com/jrcarter/PragmARC)

with Ada.Text_IO;
with PragmARC.Images;

procedure List_Max_Diff is
   function Float_Image is new PragmARC.Images.Float_Image (Number => Float);
   function Image (Number : in Float) return String;
   -- Returns the image of Number without a decimal point or fractional digits if the fractional part is zero

   function Image (Number : in Float) return String is
      Result : constant String := Float_Image (Number, Aft => 0, Exp => 0);
   begin -- Image
      if Result'Length > 1 and then Result (Result'Last - 1 .. Result'Last) = ".0" then
         return Result (Result'First .. Result'Last - 2);
      end if;

      return Result;
   end Image;

   type Float_List is array (Positive range <>) of Float with Dynamic_Predicate => Float_List'First = 1;

   List : constant Float_List := (1.0, 8.0, 2.0, -3.0, 0.0, 1.0, 1.0, -2.3, 0.0, 5.5, 8.0, 6.0, 2.0, 9.0, 11.0, 10.0, 3.0);

   Max : Float := -1.0;
begin -- List_Max_Diff
   Find : for I in 1 .. List'Last - 1 loop
      Max := Float'Max (abs (List (I) - List (I + 1) ), Max);
   end loop Find;

   Print : for I in 1 .. List'Last - 1 loop
      if abs (List (I) - List (I + 1) ) = Max then
         Ada.Text_IO.Put_Line (Item => Image (List (I) ) & ',' & Image (List (I + 1) ) & " ==> " & Image (Max) );
      end if;
   end loop Print;
end List_Max_Diff;
