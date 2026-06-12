-- Hexdump, a simplified version of Linux hd
-- User unfriendly; no error handling
--
-- usage: hexdump [-s n] [-l n] filename
--        dump the contents of filename in hexadecimal
--        -s n: skip the first n bytes of filename (default 0)
--        -l n: dump at most n bytes (default entire file)
--
-- Uses the PragmAda Reusable Components: https://github.com/jrcarter/PragmARC
--
-- J. Carter     2025 Jul

with Ada.Characters.Handling;
with Ada.Command_Line;
with Ada.Sequential_IO;
with Ada.Text_IO;
with PragmARC.Images;
with System;

procedure Hexdump is
   type Byte_Value is mod 2 ** 8;

   package Byte_IO is new Ada.Sequential_IO (Element_Type => Byte_Value);

   function Image is new PragmARC.Images.Modular_Image (Number => Byte_Value);

   type Byte_Count is mod System.Max_Binary_Modulus; -- Handle large files

   function Image is new PragmARC.Images.Modular_Image (Number => Byte_Count);

   subtype Printable is Character range Character'Val (32) .. Character'Val (126);

   File_Arg : Positive   := 1;
   Skip     : Byte_Count := 0;
   Length   : Byte_Count := Byte_Count'Last;
   Input    : Byte_IO.File_Type;
   Byte     : Byte_Value;
   Text     : String (1 .. 16);
   Next     : Natural := 1;
   Offset   : Byte_Count;
begin -- Hexdump
   Parse : loop
      if Ada.Command_Line.Argument (File_Arg) = "-s" then
         Skip := Byte_Count'Value (Ada.Command_Line.Argument (File_Arg + 1) );
         File_Arg := File_Arg + 2;
      elsif Ada.Command_Line.Argument (File_Arg) = "-l" then
         Length := Byte_Count'Value (Ada.Command_Line.Argument (File_Arg + 1) );
         File_Arg := File_Arg + 2;
      else
         exit Parse;
      end if;
   end loop Parse;

   Byte_IO.Open (File => Input, Mode => Byte_IO.In_File, Name => Ada.Command_Line.Argument (File_Arg) );

   Skip_Some : for S in 1 .. Skip loop
      Byte_IO.Read (File => Input, Item => Byte);
   end loop Skip_Some;

   Offset := Skip;

   All_Bytes : for B in 1 .. Length loop
      if Offset rem 16 = Skip rem 16 then
         Ada.Text_IO.Put (Item => Ada.Characters.Handling.To_Lower
                                     (Image (Offset, Width => 8, Zero_Filled => True, Base => 16) & "  ") );
      end if;

      exit All_Bytes when Byte_IO.End_Of_File (Input);

      Byte_IO.Read (File => Input, Item => Byte);
      Ada.Text_IO.Put (Item => Ada.Characters.Handling.To_Lower (Image (Byte, Width => 2, Zero_Filled => True, Base => 16) ) );
      Text (Next) := Character'Val (Byte);
      Offset := Offset + 1;

      if Next in 8 | 16 then
         Ada.Text_IO.Put (Item => "  ");
      else
         Ada.Text_IO.Put (Item => ' ');
      end if;

      if Next = 16 then
         Ada.Text_IO.Put (Item => '|');

         Add_Text : for I in Text'Range loop
            Ada.Text_IO.Put (Item => (if Text (I) in Printable then Text (I) else '.') );
         end loop Add_Text;

         Ada.Text_IO.Put_Line (Item => "|");
         Next := 0;
      end if;

      Next := Next + 1;
   end loop All_Bytes;

   if Next > 1 then
      Ada.Text_IO.Put (Item => (1 .. 3 * (16 - Next + 1) + (if Next < 8 then 2 else 1) => ' ') & '|');

      Final_Text : for I in 1 .. Next - 1 loop
         Ada.Text_IO.Put (Item => (if Text (I) in Printable then Text (I) else '.') );
      end loop Final_Text;

      Ada.Text_IO.Put_Line (Item => "|");
      Ada.Text_IO.Put_Line (Item => Ada.Characters.Handling.To_Lower
                                       (Image (Offset - Skip, Width => 8, Zero_Filled => True, Base => 16) ) );
   end if;

   Byte_IO.Close (File => Input);
end Hexdump;
