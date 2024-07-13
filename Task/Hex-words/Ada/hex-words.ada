-- Hex Words: find words of 4 or more characters, all characters of which are hex digits
-- J. Carter     2024 May

with Ada.Characters.Handling;
with Ada.Containers.Vectors;
with Ada.Strings.Unbounded;
with Ada.Text_IO;

procedure Hex_Words is
   use Ada.Strings.Unbounded;

   subtype Hex_Digit is Character range 'a' .. 'f';
   subtype Digit_Value is Integer range 0 .. 9;

   function Hex_Word (Line : in String) return Boolean is
      (Line'Length > 3 and (for all C of Line => C in Hex_Digit) );

   function Digital_Root (Number : in Natural) return Digit_Value;
   -- Returns the decimal digital root of Number

   function Four_Distinct (Word : in String) return Boolean with
      Pre => Hex_Word (Word);
   -- Returns True if Word has at least 4 distinct letters; False otherwise

   function Image (Number : in Natural) return String with
      Post => Image'Result'Length = 9;
   -- Returns the blank-filled decimal image of Number

   type Word_Info is record
      Word  : Unbounded_String;
      Value : Natural;
      Root  : Digit_Value;
   end record;

   function Root_Less (Left : in Word_Info; Right : in Word_Info) return Boolean is
      (if Left.Root /= Right.Root then Left.Root < Right.Root else Left.Word < Right.Word);

   function Value_Greater (Left : in Word_Info; Right : in Word_Info) return Boolean is
      (if Left.Value /= Right.Value then Left.Value > Right.Value else Left.Word < Right.Word);

   package Word_Lists is new Ada.Containers.Vectors (Index_Type => Positive, Element_Type => Word_Info);

   package Root_Sorting is new Word_Lists.Generic_Sorting ("<" => Root_Less);
   package Value_Sorting is new Word_Lists.Generic_Sorting ("<" => Value_Greater);

   function Digital_Root (Number : in Natural) return Digit_Value is
      function Digit_Sum return Natural;
      -- Sums the digits of the decimal representation of Number

      function Digit_Sum return Natural is
         Image : constant String := Number'Image;

         Sum   : Natural := 0;
      begin -- Digit_Sum
         All_Digits : for I in 2 .. Image'Last loop
            Sum := Sum + Character'Pos (Image (I) ) - Character'Pos ('0');
         end loop All_Digits;

         return Sum;
      end Digit_Sum;

      Sum : Natural := Digit_Sum;
   begin -- Digital_Root
      if Sum in Digit_Value then
         return Sum;
      end if;

      return Digital_Root (Sum);
   end Digital_Root;

   function Four_Distinct (Word : in String) return Boolean is
      type Hex_Set is array (Hex_Digit) of Boolean;

      Set   : Hex_Set := (others => False);
      Count : Natural := 0;
   begin -- Four_Distinct
      Check_All : for C of Word loop
         Set (C) := True;
      end loop Check_All;

      Count_Them : for B of Set loop
         if B then
            Count := Count + 1;
         end if;
      end loop Count_Them;

      return Count > 3;
   end Four_Distinct;

   function Image (Number : in Natural) return String is
      Result : constant String := Number'Image;
   begin -- Image
      return (1 .. 9 - Result'Length => ' ') & Result;
   end Image;

   Input    : Ada.Text_IO.File_Type;
   Info     : Word_Info;
   Word     : Word_Lists.Vector;
   Distinct : Word_Lists.Vector;
begin -- Hex_Words
   Ada.Text_IO.Open (File => Input, Mode => Ada.Text_IO.In_File, Name => "unixdict.txt");

   All_Words : loop
      exit All_Words when Ada.Text_IO.End_Of_File (Input);

      One_Word : declare
         Line : constant String := Ada.Characters.Handling.To_Lower (Ada.Text_IO.Get_Line (Input) );
      begin -- One_Word
         if Hex_Word (Line) then
            Info.Word := To_Unbounded_String (Line);
            Info.Value := Integer'Value ("16#" & Line & '#');
            Info.Root := Digital_Root (Info.Value);
            Word.Append (New_Item => Info);

            if Four_Distinct (Line) then
               Distinct.Append (New_Item => Info);
            end if;
         end if;
      end One_Word;
   end loop All_Words;

   Ada.Text_IO.Close (File => Input);

   Root_Sorting.Sort (Container => Word);
   Value_Sorting.Sort (Container => Distinct);

   Print_All : for I in 1 .. Word.Last_Index loop
      Print_One : declare
         Info : Word_Info renames Word.Element (I);
      begin -- Print_One
         Ada.Text_IO.Put_Line
            (Item => To_String (Info.Word) & (1 .. 6 - Length (Info.Word) => ' ') & Image (Info.Value) & Info.Root'Image);
      end Print_One;
   end loop Print_All;

   Ada.Text_IO.Put_Line (Item => Word.Last_Index'Image & " total words");
   Ada.Text_IO.New_Line;

   Output_Distinct : for I in 1 ..Distinct.Last_Index loop
      One_Distinct : declare
         Info : Word_Info renames Distinct.Element (I);
      begin -- One_Distinct
         Ada.Text_IO.Put_Line
            (Item => To_String (Info.Word) & (1 .. 6 - Length (Info.Word) => ' ') & Image (Info.Value) & Info.Root'Image);
      end One_Distinct;
   end loop Output_Distinct;

   Ada.Text_IO.Put_Line (Item => Distinct.Last_Index'Image & " words with 4 or more distinct letters");
end Hex_Words;
