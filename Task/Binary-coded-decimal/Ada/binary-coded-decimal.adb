-- Binary coded decimal
-- J. Carter     2024 Jul
-- Uses the PragmAda Reusable Components (https://github.com/jrcarter/PragmARC)

with Ada.Text_IO;
with Ada.Unchecked_Conversion;
with PragmARC.Images;

procedure Binary_Coded_Decimal is
   subtype BCD_Digit is Integer range 0 .. 9;

   generic -- BCD_Ops
      type BCD is array (Positive range <>) of BCD_Digit; -- Little endian
   package BCD_Ops is
      function Image (Item : in BCD) return String;
      -- Returns the decimal representation of Item without any leading spaces or zeroes

      function "+" (Left : in BCD; Right : in BCD) return BCD with
         Pre => Left'First = 1 and Right'First = 1 and Left'Last = Right'Last;

      function "-" (Left : in BCD; Right : in BCD) return BCD with
         Pre => Left'First = 1 and Right'First = 1 and Left'Last = Right'Last;
   end BCD_Ops;

   type Unpacked_BCD is array (Positive range <>) of BCD_Digit with Component_Size => 8;
   type Packed_BCD   is array (Positive range <>) of BCD_Digit with Component_Size => 4;
   -- Little endian

   function Hex_Image (Item : in Packed_BCD) return String with
      Pre => Item'Length = 2;
   -- Treats the 2 nibbles of Item as a byte, and returns the hexadecimal representation of that byte as 2 digits, zero filled

   package body BCD_Ops is
      function Image (Item : in BCD) return String is
         Result : String (Item'Range);
         Last   : Natural := Item'First;
      begin -- Image
         Find_Last : for I in reverse Item'Range loop
            if Item (I) /= 0 then
               Last := I;

               exit Find_Last;
            end if;
         end loop Find_Last;

         All_Digits : for I in Item'First .. Last loop
            Result (Last - I + Item'First) := Character'Val (Item (I) + Character'Pos ('0') );
         end loop All_Digits;

         return Result (Item'First .. Last);
      end Image;

      function "+" (Left : in BCD; Right : in BCD) return BCD is
         Result : BCD (Left'Range);
         Carry  : Natural := 0;
         Sum    : Natural;
      begin -- "+"
         All_Digits : for I in Left'Range loop
            Sum := Left (I) + Carry + Right (I);
            Result (I) := Sum rem 10;
            Carry := Sum / 10;
         end loop All_Digits;

         return Result;
      end "+";

      function "-" (Left : in BCD; Right : in BCD) return BCD is
         Result : BCD (Left'Range);
         Borrow : Natural := 0;
         Diff   : Natural;
      begin -- "-"
         All_Digits : for I in Left'Range loop
            Diff := Left (I) - Borrow;

            if Diff < Right (I) then
               Diff := Diff + 10;
               Borrow := 1;
            else
               Borrow := 0;
            end if;

            Result (I) := Diff - Right (I);
         end loop All_Digits;

         return Result;
      end "-";
   end BCD_Ops;

   package Unpacked_Ops is new BCD_Ops (BCD => Unpacked_BCD);
   use Unpacked_Ops;
   package Packed_Ops is new BCD_Ops (BCD => Packed_BCD);
   use Packed_Ops;

   function Hex_Image (Item : in Packed_BCD) return String is
      type Byte is mod 2 ** 8 with Size => 8;

      function Image is new PragmARC.Images.Modular_Image (Number => Byte);

      subtype Item_Range is Packed_BCD (1 .. 2);

      function As_Byte is new Ada.Unchecked_Conversion (Source => Item_Range, Target => Byte);
   begin -- Hex_Image
      return Image (As_Byte (Item), Base => 16, Width => 2, Zero_Filled => True);
   end Hex_Image;

   subtype Unpacked_4 is Unpacked_BCD (1 .. 4); -- 4 so we have 2 full bytes for the hex output of the last example
   subtype Packed_4 is Packed_BCD (1 .. 4);

   B01 : constant Unpacked_4 := (1 => 1, 2 .. 4 => 0);
   B19 : constant Unpacked_4 := (1 => 9, 2 => 1, 3 .. 4 => 0);
   B30 : constant Unpacked_4 := (1 => 0, 2 => 3, 3 .. 4 => 0);
   B99 : constant Unpacked_4 := (1 => 9, 2 => 9, 3 .. 4 => 0);

   LU : Unpacked_4;
   RU : Unpacked_4;
   AU : Unpacked_4;
   LP : Packed_4;
   RP : Packed_4;
   AP : Packed_4;
begin -- Binary_Coded_Decimal
   Ada.Text_IO.Put_Line (Item => "Unpacked");
   LU := B19;
   RU := B01;
   AU := LU + RU;
   Ada.Text_IO.Put_Line (Item => Image (LU) & " + " & Image (RU) & " =  " & Image (AU) );
   LU := B30;
   RU := B01;
   AU := LU - RU;
   Ada.Text_IO.Put_Line (Item => Image (LU) & " - " & Image (RU) & " =  " & Image (AU) );
   LU := B99;
   RU := B01;
   AU := LU + RU;
   Ada.Text_IO.Put_Line (Item => Image (LU) & " + " & Image (RU) & " = "  & Image (AU) );
   Ada.Text_IO.Put_Line (Item => "Packed");
   LP := Packed_BCD (B19);
   RP := Packed_BCD (B01);
   AP := LP + RP;
   Ada.Text_IO.Put_Line (Item => "    " & Image (LP) & " +  " & Image (RP) & " =   " & Image (AP) );
   Ada.Text_IO.Put_Line
      (Item => "Hex " & Hex_Image (LP (1 .. 2) ) & " + " & Hex_Image (RP (1 .. 2) ) & " =   " & Hex_Image (AP (1 .. 2) ) );
   LP := Packed_BCD (B30);
   RP := Packed_BCD (B01);
   AP := LP - RP;
   Ada.Text_IO.Put_Line (Item => "    " & Image (LP) & " -  " & Image (RP) & " =   " & Image (AP) );
   Ada.Text_IO.Put_Line
      (Item => "Hex " & Hex_Image (LP (1 .. 2) ) & " - " & Hex_Image (RP (1 .. 2) ) & " =   " & Hex_Image (AP (1 .. 2) ) );
   LP := Packed_BCD (B99);
   RP := Packed_BCD (B01);
   AP := LP + RP;
   Ada.Text_IO.Put_Line (Item => "    " & Image (LP) & " +  " & Image (RP) & " =  "  & Image (AP) );
   Ada.Text_IO.Put_Line (Item => "Hex " & Hex_Image (LP (1 .. 2) ) & " + " & Hex_Image (RP (1 .. 2) ) & " = " &
                                 Hex_Image (AP (3 .. 4) ) & Hex_Image  (AP (1 .. 2) ) );
end Binary_Coded_Decimal;
