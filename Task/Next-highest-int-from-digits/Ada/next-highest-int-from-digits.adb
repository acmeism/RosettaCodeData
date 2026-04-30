-- Next highest integer with same digits
-- J. Carter     2024 June
-- Uses the PragmAda Reusable Components (https://github.com/jrcarter/PragmARC)

with Ada.Text_IO;
with PragmARC.Permutations;
with PragmARC.Sorting.Insertion;

procedure Next_Highest is
   package Permutations is new PragmARC.Permutations (Element => Character);
   procedure Sort is new PragmARC.Sorting.Insertion (Element => Character, Index => Positive, Sort_Set => String);

   subtype Digit is Character range '0' .. '9';

   function Valid (S : in String) return Boolean is
      (S'First = 1 and S'Length > 0 and (for all C of S => C in Digit) );

   function Next_P (Value : in String) return String with
      Pre => Valid (Value);
   -- Returns the smallest integer > Value that can be produced from Value's decimal digits, using permutations
   -- Returns zero if there is no such integer

   function Next_S (Value : in String) return String with
      Pre => Valid (Value);
   -- Returns the smallest integer > Value that can be produced from Value's decimal digits, using the Scan, Sort, Scan, and Swap
   -- (SSSS) algorithm
   -- Returns zero if there is no such integer

   function Next_P (Value : in String) return String is
      procedure Check (Image : in Permutations.Sequence; Stop : in out Boolean);
      -- Checks if Image represents an integer > Value and smaller than Smallest
      -- If so, sets Found to True and Smallest to the represented value

      Found    : Boolean := False;
      Smallest : String  := (Value'Range => '9');

      procedure Check (Image : in Permutations.Sequence; Stop : in out Boolean) is
         Number : constant String := String (Image);
      begin -- Check
         if Number > Value then
            Found := True;
            Smallest := (if Number < Smallest then Number else Smallest);
         end if;
      end Check;
   begin -- Next_P
      if Value'Length < 2 or (Value'Length = 2 and Value < "12") then
         return "0";
      end if;

      Permutations.Generate (Initial => Permutations.Sequence (Value), Process => Check'Access);

      return (if Found then Smallest else "0");
   end Next_P;

   function Next_S (Value : in String) return String is
      Work   : String := Value;
      Found  : Boolean := False;
      Lower  : Positive;
      Higher : Positive;
   begin -- Next_S
      Scan_Lower : for I in reverse 1 .. Work'Last - 1 loop
         if (for some C of Work (I + 1 .. Work'Last) => Work (I) < C) then
            Found := True;
            Lower := I;

            exit Scan_Lower;
         end if;
      end loop Scan_Lower;

      if not Found then
         return "0";
      end if;

      Sort (Set => Work (Lower + 1 .. Work'Last) );

      Scan_Higher : for I in Lower + 1 .. Work'Last loop -- The Found test above ensures that this will always assign to Higher
         if Work (I) > Work (Lower) then
            Higher := I;

            exit Scan_Higher;
         end if;
      end loop Scan_Higher;

      Swap : declare
         Temp : constant Character := Work (Lower);
      begin -- Swap
         Work (Lower) := Work (Higher);
         Work (Higher) := Temp;
      end Swap;

      return Work;
   end Next_S;

   Test_1  : constant String :=        "0";
   Test_2  : constant String :=        "9";
   Test_3  : constant String :=       "12";
   Test_4  : constant String :=       "21";
   Test_5  : constant String :=    "12453";
   Test_6  : constant String :=   "738440";
   Test_7  : constant String := "45072010";
   Test_8  : constant String := "95322020";
   Stretch : constant String := "9589776899767587796600";
begin -- Next_Highest
   Ada.Text_IO.Put_Line (Item => "Using permutations");
   Ada.Text_IO.Put_Line (Item => (1 .. 8 - Test_1'Length => ' ') & Test_1 & ' ' & Next_P (Test_1) );
   Ada.Text_IO.Put_Line (Item => (1 .. 8 - Test_2'Length => ' ') & Test_2 & ' ' & Next_P (Test_2) );
   Ada.Text_IO.Put_Line (Item => (1 .. 8 - Test_3'Length => ' ') & Test_3 & ' ' & Next_P (Test_3) );
   Ada.Text_IO.Put_Line (Item => (1 .. 8 - Test_4'Length => ' ') & Test_4 & ' ' & Next_P (Test_4) );
   Ada.Text_IO.Put_Line (Item => (1 .. 8 - Test_5'Length => ' ') & Test_5 & ' ' & Next_P (Test_5) );
   Ada.Text_IO.Put_Line (Item => (1 .. 8 - Test_6'Length => ' ') & Test_6 & ' ' & Next_P (Test_6) );
   Ada.Text_IO.Put_Line (Item => (1 .. 8 - Test_7'Length => ' ') & Test_7 & ' ' & Next_P (Test_7) );
   Ada.Text_IO.Put_Line (Item => (1 .. 8 - Test_8'Length => ' ') & Test_8 & ' ' & Next_P (Test_8) );
   Ada.Text_IO.New_Line;
   Ada.Text_IO.Put_Line (Item => "Using SSSS");
   Ada.Text_IO.Put_Line (Item => (1 .. 8 - Test_1'Length => ' ') & Test_1 & ' ' & Next_S (Test_1) );
   Ada.Text_IO.Put_Line (Item => (1 .. 8 - Test_2'Length => ' ') & Test_2 & ' ' & Next_S (Test_2) );
   Ada.Text_IO.Put_Line (Item => (1 .. 8 - Test_3'Length => ' ') & Test_3 & ' ' & Next_S (Test_3) );
   Ada.Text_IO.Put_Line (Item => (1 .. 8 - Test_4'Length => ' ') & Test_4 & ' ' & Next_S (Test_4) );
   Ada.Text_IO.Put_Line (Item => (1 .. 8 - Test_5'Length => ' ') & Test_5 & ' ' & Next_S (Test_5) );
   Ada.Text_IO.Put_Line (Item => (1 .. 8 - Test_6'Length => ' ') & Test_6 & ' ' & Next_S (Test_6) );
   Ada.Text_IO.Put_Line (Item => (1 .. 8 - Test_7'Length => ' ') & Test_7 & ' ' & Next_S (Test_7) );
   Ada.Text_IO.Put_Line (Item => (1 .. 8 - Test_8'Length => ' ') & Test_8 & ' ' & Next_S (Test_8) );
   Ada.Text_IO.New_Line;
   Ada.Text_IO.Put_Line (Item => Stretch & ' ' & Next_S (Stretch) );
end Next_Highest;
