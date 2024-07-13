-- Parse scanned UPC-A codes
-- J. Carter     2024 May

with Ada.Containers.Hashed_Maps;
with Ada.Strings.Fixed;
with Ada.Strings.Hash;
with Ada.Text_IO;

procedure UPC is
   subtype Digit_Pattern is String (1 .. 7);
   subtype Digit_Character is Character range '0' .. '9';
   type Pattern_Map is array (Digit_Character) of Digit_Pattern;

   package Digit_Maps is new Ada.Containers.Hashed_Maps (Key_Type        => Digit_Pattern,
                                                         Element_Type    => Digit_Character,
                                                         Hash            => Ada.Strings.Hash,
                                                         Equivalent_Keys => "=");

   Start_Stop_Marker  : constant String := "# #";
   Middle_Marker      : constant String := " # # ";

   Scan_Length : constant := 2 * Start_Stop_Marker'Length + Middle_Marker'Length + 12 * Digit_Pattern'Length;

   procedure Parse (Count : in Positive; Scan : in String; Reversed : in Boolean := False) with
      Pre => Scan'First = 1 and Scan'Length = Scan_Length;
   -- Parses Scan and prints the result
   -- Count is the line #
   -- If Scan is invalid and not Reversed, tries to parse a reversed version of Scan before printing that Scan is invalid

   Left_Pattern_Map : constant Pattern_Map :=
      ('0' => "   ## #",
       '1' => "  ##  #",
       '2' => "  #  ##",
       '3' => " #### #",
       '4' => " #   ##",
       '5' => " ##   #",
       '6' => " # ####",
       '7' => " ### ##",
       '8' => " ## ###",
       '9' => "   # ##");
   Right_Pattern_Map : constant Pattern_Map :=
      ('0' => "###  # ",
       '1' => "##  ## ",
       '2' => "## ##  ",
       '3' => "#    # ",
       '4' => "# ###  ",
       '5' => "#  ### ",
       '6' => "# #    ",
       '7' => "#   #  ",
       '8' => "#  #   ",
       '9' => "### #  ");

   Left_Map  : Digit_Maps.Map;
   Right_Map : Digit_Maps.Map;

   function Image (Count : in Positive) return String is
      (if Count < 10 then Count'Image else Count'Image (2 .. 3) );

   procedure Parse (Count : in Positive; Scan : in String; Reversed : in Boolean := False) is
      function Backwards return String with
         Post => Backwards'Result'First = Scan'First and
                 Backwards'Result'Last = Scan'Last and
                 (for all I in Scan'Range => Backwards'Result (I) = Scan (Scan'Last - I + 1) );

      function Backwards return String is
         Right  : Positive := Scan'Last;
         Result : String   := Scan;
      begin -- Backwards
         Swap : for Left in 1 .. Scan'Last / 2 loop
            Result (Left) := Scan (Right);
            Result (Right) := Scan (Left);
            Right := Right - 1;
         end loop Swap;

         return Result;
      end Backwards;

      Result : String (1 .. 12);
      Start  : Positive := 1 + Start_Stop_Marker'Length;
      Stop   : Positive;
   begin -- Parse
      if Scan (1 .. Start_Stop_Marker'Length) /= Start_Stop_Marker or
         Scan (Scan'Last - Start_Stop_Marker'Length + 1 .. Scan'Last) /= Start_Stop_Marker
      then
         Ada.Text_IO.Put_Line (Item => Image (Count) & ' ' & Scan & ": invalid, missing start or stop marker");

         return;
      end if;

      if Scan (1 + Start_Stop_Marker'Length + 6 * Digit_Pattern'Length ..
               1 + Start_Stop_Marker'Length + 6 * Digit_Pattern'Length + Middle_Marker'Length - 1) /= Middle_Marker
      then
         Ada.Text_IO.Put_Line (Item => Image (Count) & ' ' & Scan & ": invalid, missing middle marker");

         return;
      end if;

      Left_Side : for I in 1 .. 6 loop
         Stop := Start + Digit_Pattern'Length - 1;

         if not Left_Map.Contains (Scan (Start .. Stop) ) then
            if not Reversed then
               Parse (Count => Count, Scan => Backwards, Reversed => True);
            else
               Ada.Text_IO.Put_Line (Item => Image (Count) & ": invalid");
            end if;

            return;
         end if;

         Result (I) := Left_Map.Element (Scan (Start .. Stop) );
         Start := Stop + 1;
      end loop Left_Side;

      Start := Start + Middle_Marker'Length;

      Right_Side : for I in 7 .. 12 loop
         Stop := Start + Digit_Pattern'Length - 1;

         if not Right_Map.Contains (Scan (Start .. Stop) ) then
            if not Reversed then
               Parse (Count => Count, Scan => Backwards, Reversed => True);
            else
               Ada.Text_IO.Put_Line (Item => Image (Count) & ": invalid");
            end if;

            return;
         end if;

         Result (I) := Right_Map.Element (Scan (Start .. Stop) );
         Start := Stop + 1;
      end loop Right_Side;

      Ada.Text_IO.Put_Line (Item => Image (Count) & ": " & Result & (if Reversed then " reversed" else "") );
   end Parse;

   Count : Natural := 0;
begin -- UPC
   Fill_Left : for D in Left_Pattern_Map'Range loop
      Left_Map.Insert (Key => Left_Pattern_Map (D), New_Item => D);
   end loop Fill_Left;

   Fill_Right : for D in Right_Pattern_Map'Range loop
      Right_Map.Insert (Key => Right_Pattern_Map (D), New_Item => D);
   end loop Fill_Right;

   All_Lines : loop
      exit All_Lines when Ada.Text_IO.End_Of_File;

      One_Line : declare
         Line : constant String := Ada.Strings.Fixed.Trim (Ada.Text_IO.Get_Line, Ada.Strings.Both);
      begin -- One_Line
         Count := Count + 1;

         if Line'Length /= Scan_Length then
            Ada.Text_IO.Put_Line (Item => Image (Count) & " invalid scan;" & Line'Length'Image & "/=" & Scan_Length'Image);
         else
            Parse (Count => Count, Scan => Line);
         end if;
      end One_Line;
   end loop All_Lines;
end UPC;
