-- Three-word location
-- J. Carter     2023 May
-- Uses the PragmAda Reusable Components (https://github.com/jrcarter/PragmARC)

with Ada.Text_IO;
with PragmARC.Images;

procedure Three_Word is
   type U43 is mod 2 ** 43;
   subtype Word is String (1 .. 6);

   function Image is new PragmARC.Images.Modular_Image (Number => U43);
   function Image is new PragmARC.Images.Float_Image (Number => Float);

   Lat  : constant String :=  "28.3852";
   Long : constant String := "-81.5638";

   LL_Mix : U43 := U43 ( (Float'Value (Lat) + 90.0) * 10_000.0) * 2 ** 22 + U43 ( (Float'Value (Long) + 180.0) * 10_000.0);
   W3n    : U43 := LL_Mix rem 2 ** 14;             -- Number for 3rd word
   W2n    : U43 := (LL_Mix / 2 ** 14) rem 2 ** 14; --    "    "  2nd   "
   W1n    : U43 := LL_Mix / 2 ** 28;               --    "    "  1st   "

   W1 : constant Word := 'W' & Image (W1n, Width => 5, Zero_Filled => True); -- 1st word
   W2 : constant Word := 'W' & Image (W2n, Width => 5, Zero_Filled => True); -- 2nd   "
   W3 : constant Word := 'W' & Image (W3n, Width => 5, Zero_Filled => True); -- 3rd   "
begin -- Three_Word
   Ada.Text_IO.Put (Item => Lat & ", " & Long & " => " & W1 & ' ' & W2 & ' ' & W3 & " => ");

   -- Reverse the process
   W1n := U43'Value (W1 (2 .. 6) );
   W2n := U43'Value (W2 (2 .. 6) );
   W3n := U43'Value (W3 (2 .. 6) );
   LL_Mix := W1n * 2 ** 28 + W2n * 2 ** 14 + W3n;
   Ada.Text_IO.Put_Line  (Item => Image (Float (LL_Mix / 2 ** 22) / 10_000.0 - 90.0, Fore => 0, Aft => 4, Exp => 0) & ", " &
                                  Image (Float (LL_Mix rem 2 ** 22) / 10_000.0 - 180.0, Fore => 0, Aft => 4, Exp => 0) );
end Three_Word;
